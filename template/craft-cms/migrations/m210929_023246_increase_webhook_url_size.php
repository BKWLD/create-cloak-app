<?php

namespace craft\contentmigrations;

use Craft;
use craft\db\Migration;

/**
 * m210929_023246_increase_webhook_url_size migration.
 */
class m210929_023246_increase_webhook_url_size extends Migration
{
    /**
     * @inheritdoc
     */
    public function safeUp()
    {
        $this->alterColumn('webhooks', 'url', 'text');
    }

    /**
     * @inheritdoc
     */
    public function safeDown()
    {
        $this->alterColumn('webhooks', 'url', 'string');
    }
}
