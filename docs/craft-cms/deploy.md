# Craft CMS - Deploy

You will intially install the Craft CMS locally.  When you are ready to collaborate with others, you'll typically setup a Digital Ocean (DO) Droplet through Forge to host the CMS.  These are steps to follow.  This tends to take 1-2hrs.

1. Create a new DO Team

2. Gp to Spaces and create a new Space in the San Francisco datacenter (usually SFO3).  Choose to Enable CDN.  Make the Space name a slugified version of the project name.

3. Create a new [Personal Access Token / API Key](https://cloud.digitalocean.com/account/api/tokens) for the team called "Forge" and capture the token for later use.  Also, from the same screen, generate a Spaces Access key called "Craft" and capture it's key and seecret for later use.

4. Add your Personal Access Token as a [new Service Provider in Forge](https://forge.laravel.com/user/profile#/providers).

5. Create a new Server in Forge using that Service Provider.
  - Start of with a small one; you can always go up in scale but you can't go down to a Droplet with a smaller disk size.  I've been doing the 1GB Premium Intel one ($6/mo).  Choose the same datacenter as your Space (usually SFO3). The rest of the setting should be straightforward.
  - Forge will show you the sudo and database passwords in a modal window.  Store these in Passwork within the "Hosting - Privileged" Vault.

6. After it's done provisioning, create a new Site.  Make the root domain what you intent it to ultimately be (usually cms.clientdomain.com) and add a *.bukwild.com subdomain as an alias (like client-cms.bukwild.com).  The rest of the defaults are fine, though choose to create a database called `craft`.

7. While that provisions, delete the "default" site that was created.

8. Go into the Forge UI for the Site and click "Git Repository" to connect it to GitLab.  The "Repository" is the full path of the URL of the repo, like "client-group/client-project".  Uncheck "Install composer dependencies" since these aren't in the root.

9. Once the setup of the repo for the Site succeeds, edit the Deploy Script, replacing the `git pull ...` line with `chmod +x craft-cms/deploy.sh && craft-cms/deploy.sh` which will run our own commands to update and build the CMS.

10. Click "Enable Quick Deploy" button so the deploy commands will run on git push.

11. Click on the Server for the Site and go to PHP and...
  - Set "Max File Upload Size" to `100`
  - Set "Max Execution Time" to `120`
  - Enable OPCache

12. Login to the Bukwild CloudFlare account and edit the DNS Zones for bukwild.com to create an `A` record using the IP of the server from Forge,  the subdomain you added as an alias when setting up the new Site, and turning "Proxy status" off.

13. Go back to Forge, go the Site you created, click "SSL", create a new LetsEncrypt certificate, and edit the Domains to *only* inlcude the bukwild.com alias (since the other domain won't exist yet).

14. Also in the Site, go to Meta and change the Web Directory to `/craft-cms/web`.

15. Go the Environment tab and paste the `.env` from your local directory there.  Then, populate the following values:
  - Set `ENVIRONMENT=production`
  - Set `DB_DATABASE=craft`
  - Set `DB_USER=forge`
  - Set `DB_PASSWORD` to the password that Forge gave you when you created the Server
  - Set `SPACES_API_KEY` to the Space key that was generated earlier on
  - Set `SPACES_SECRET` to the Space secret that was generated earlier on
  - Set `SPACES_BUCKET` to the Space Name that you gave to the Space when you created it.
  - Set `PRIMARY_SITE_URL` to your *.netlify.app URL or comment out
  - Set `BASE_CP_URL` to the *.bukwild.com alias, including https://
  - Set `EMAIL_PASSWORD` to the sned.bukwild.com Mailgun SMTP password from Passwork by following the link in the .env comment.
  - Set `SENTRY_DSN` to a new DNS for a new Sentry project you should create for the CMS (different from projects created for public sites)

16. Export your local database and import it into the DO database using Querious or some other means.

17. You should now be able to visit the *.bukwild.com hostname you created and login using the credentials you created locally.  If you used insecure credentials or a generic username like `admin`, this is a good time to invite yourself using a unique username with a good password and to delete your orginial user.

18. You are done!  You may want to review the [config docs](./config.md) at the is point to take additional steps like:
  - Delete the "Local" Assets Volume
  - Customize the CMS name and icons
