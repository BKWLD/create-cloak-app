<?php

namespace craft\contentmigrations;

use Craft;
use craft\db\Migration;
use craft\elements\Entry;
use verbb\supertable\SuperTable;

/**
 * m210710_202119_create_hello_world_tower migration.
 */
class m210710_202119_create_hello_world_tower extends Migration
{
    /**
     * @inheritdoc
     */
    public function safeUp()
    {
        $this->makeHomepage();
        $this->make404();
        $this->make500();
    }

    private function makeHomepage()
    {
        $tower = $this->makeTowerEntry();
        $tower->title = 'Homepage';
        $tower->slug = '__home__';
        $tower->setFieldValues([
            'blocks' => [

                [ // Marquee block
                    'type' => 'simpleMarquee',
                    'fields' => [
                        'fullWysiwyg' => '<h1>Heya World</h1>',
                        'buttons' => [
                            [
                                'type' => $this->getButtonsTypeId(),
                                'fields' => [
                                    'label' => 'Search',
                                    'to' => 'https://www.google.com',
                                ]
                            ]
                        ]
                    ],
                ],

                // WIP, see https://github.com/spicywebau/craft-neo/issues/478
                // [  // Wrapper
                //     'type' => 'wrapper',
                //     'children' => [

                //         [ // Spacer block
                //             'type' => 'spacer',
                //             'fields' => [ 'spacing' => 'm' ],
                //         ],

                //         [ // Spacer block
                //             'type' => 'spacer',
                //             'fields' => [ 'spacing' => 'm' ],
                //         ],
                //     ],
                // ]

            ],
        ]);
        Craft::$app->elements->saveElement($tower);
    }

    private function make404()
    {
        $tower = $this->makeTowerEntry();
        $tower->title = 'Page Not Found';
        $tower->slug = 'page-not-found';
        $tower->setFieldValues([
            'blocks' => [
                [
                    'type' => 'simpleMarquee',
                    'fields' => [
                        'text' => 'Page Not Found',
                        'buttons' => [
                            [
                                'type' => $this->getButtonsTypeId(),
                                'fields' => [
                                    'label' => 'Return home',
                                    'to' => '/',
                                ]
                            ]
                        ]
                    ],
                ],
            ],
        ]);
        Craft::$app->elements->saveElement($tower);
    }

    private function make500()
    {
        $tower = $this->makeTowerEntry();
        $tower->title = 'Error';
        $tower->slug = 'error';
        $tower->setFieldValues([
            'blocks' => [
                [
                    'type' => 'simpleMarquee',
                    'fields' => [
                        'text' => 'An Error Occurred',
                        'buttons' => [
                            [
                                'type' => $this->getButtonsTypeId(),
                                'fields' => [
                                    'label' => 'Return home',
                                    'to' => '/',
                                ]
                            ]
                        ]
                    ],
                ],
            ],
        ]);
        Craft::$app->elements->saveElement($tower);
    }

    private function makeTowerEntry()
    {
        $section = Craft::$app->sections->getSectionByHandle('towers');
        $type = $section->getEntryTypes()[0];
        $tower = new Entry();
        $tower->sectionId = $section->id;
        $tower->typeId = $type->id;
        return $tower;
    }

    // https://verbb.io/craft-plugins/super-table/docs/template-guides/php-example
    private function getButtonsTypeId()
    {
        $field = Craft::$app->getFields()->getFieldByHandle('buttons');
        $blockTypes = SuperTable::$plugin->getService()
            ->getBlockTypesByFieldId($field->id);
        return $blockTypes[0]->id;
    }

    /**
     * @inheritdoc
     */
    public function safeDown()
    {
        echo "m210710_202119_create_hello_world_tower cannot be reverted.\n";
        return false;
    }
}
