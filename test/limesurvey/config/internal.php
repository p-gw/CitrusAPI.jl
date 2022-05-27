<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * This file contains configuration parameters for the Yii framework.
 * Do not change these unless you know what you are doing.
 *
 */

if (!file_exists(dirname(__FILE__) . '/config.php')) {
    $userConfig = require(dirname(__FILE__) . '/config-sample-mysql.php');
} else {
    $userConfig = require(dirname(__FILE__) . '/config.php');
}

if (!date_default_timezone_set(@date_default_timezone_get())) {
    date_default_timezone_set('Europe/London');
}


if (function_exists('mb_internal_encoding')) {
    // Needed to substring arabic etc
    mb_internal_encoding('UTF-8');
} else {
    // Do nothing, will be checked in installation
}

$internalConfig = array(
    'basePath' => dirname(dirname(__FILE__)),

    'name' => 'LimeSurvey',
    'localeClass' =>  'LSYii_Locale',
    'defaultController' => 'surveys',

    'aliases' => array(

        // LimeSurvey's Yii modules
        'modules' => realpath(__DIR__ . '/../../modules'),

        // Third party path
        'third_party' => realpath(__DIR__ . '/../../third_party'),
        'core' => realpath(__DIR__ . '/../../assets/packages'),
        'fonts' => realpath(__DIR__ . '/../../assets/fonts'),

        // yiistrap configuration
        'bootstrap' => realpath(__DIR__ . '/../extensions/bootstrap'),
        'vendor.twbs.bootstrap.dist' => realpath(__DIR__ . '/../extensions/bootstrap'),
        // yiiwheels configuration
        'yiiwheels' => realpath(__DIR__ . '/../extensions/yiiwheels'),
        'vendor.twbs.bootstrap.dist',

        //Basic questiontype objects
        'questiontypes' => realpath(__DIR__ . '/../core/QuestionTypes')
    ),

    /*
    here you can load the different modules
    more about YII modules :
    https://www.yiiframework.com/doc/guide/1.1/en/basics.module
    */
    'modules' => array(

        //Root Modules are real Yii Modules and can be initiate like this:
        'HelloWorld' => array(
          'class' => 'modules.root.HelloWorld.HelloWorldModule',
        ),

        /* Here you can unlock Gii
        'gii'=>array(
            'class'=>'system.gii.GiiModule',
            'password'=>'YOURPASSWORD',
            'newFileMode'=>0666,
            'newDirMode'=>0777,
        ),
        */
    ),
    'params' => array(
        'defaultPageSize' => 10, // Default page size for most of the grids
        'pageSizeOptions' => array(5 => 5, 10 => 10, 20 => 20, 50 => 50, 100 => 100), // Default page size options for most of the grids
        'pageSizeOptionsTokens' => array(5 => 5, 10 => 10, 25 => 25, 50 => 50, 100 => 100, 250 => 250, 500 => 500, 1000 => 1000, 2500 => 2500, 5000 => 5000, 10000 => 10000), // Tokens needs different options
        'defaultEllipsizeHeaderValue' => 30, // Default max characters before ellipsizing the headers of responses grid
        'defaultEllipsizeQuestionValue' => 50, // Default max characters before ellipsizing the questions inside responses grid
    ),

    'import' => array(
        'application.core.*',
        'application.core.db.*',
        'application.models.*',
        'application.models.Interfaces.*',
        'application.models.Traits.*',
        'application.helpers.*',
        'application.controllers.*',
        'application.modules.*',
        'bootstrap.helpers.*',
        'bootstrap.widgets.*',
        'bootstrap.behaviors.*',
        'yiiwheels.widgets.select2.WhSelect2',
        'third_party.Twig.*',
        'third_party.sodium.*',
        'ext.captchaExtended.CaptchaExtendedAction',
        'ext.captchaExtended.CaptchaExtendedValidator',
        'questiontypes.*'
    ),
    'preload' => array('log', 'ETwigViewRenderer'),
    'components' => array(
        // yiistrap configuration
        'bootstrap' => array(
            'class' => 'bootstrap.components.TbApi',
        ),
        // yiiwheels configuration
        'yiiwheels' => array(
            'class' => 'yiiwheels.YiiWheels',
        ),
        'sodium' => array(
            'class' => 'LSSodium',
       ),
        'sodiumOld' => [
            'class' => 'LSSodiumOld'
        ],
        'clientScript' => array(
            'packages' => array_merge(
                require('third_party.php'),
                require('packages.php'),
                require('questiontypes.php'),
                require('fonts.php')
            ),
            'class' => 'application.core.LSYii_ClientScript'
        ),

        'urlManager' => array(
            'urlFormat' => 'get',
            'rules' => require('routes.php'),
            'showScriptName' => true,
        ),
        // These are defaults and are later overwritten in LSYii_Application by a path based on config tempdir/tempurl
        'assetManager' => array(
            'excludeFiles' => array("config.xml", "node_modules", "src"),
            'class' => 'application.core.LSYii_AssetManager'
        ),
        /* Leave default errorhandler : managed in LSYii_Application->onException */
        'errorHandler' => [
        ],
        'request' => array(
            'class' => 'LSHttpRequest',
            'enableCsrfValidation' => true, // CSRF protection
            'enableCookieValidation' => false, // Enable to activate cookie protection
            'noCsrfValidationParams' => array(),
            'noCsrfValidationRoutes' => array(
                'remotecontrol',
                'plugins/unsecure',
            ),
            'csrfCookie' => array(
                'secure' => ((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || (isset($_SERVER['SERVER_PORT']) && $_SERVER['SERVER_PORT'] == 443)),
                'httpOnly' => true
            ),
        ),
        'user' => array(
            'class' => 'LSWebUser',
        ),
        'log' => array(
            'class' => 'CLogRouter',
            'routes' => array(
                'vardump' => array(
                    'class' => 'CWebLogRoute',
                    'categories' => 'vardump', // tracevar function
                    'enabled' => isset($userConfig['config']['debug']) && $userConfig['config']['debug'] >= 1,
                ),
                'profile' => array(
                    'class' => 'CProfileLogRoute'
                ),

                // Log file saved in /tmp/runtime/plugin.log
                'plugin' => array(
                    'class' => 'CFileLogRoute',
                    'levels' => 'trace, info, error, warning',
                    'logFile' => 'plugin.log',
                    'categories' => 'plugin.*'  // The category will be the name of the plugin
                )
            )
        ),
        'cache' => array(
            'class' => defined('YII_DEBUG') && YII_DEBUG ? 'system.caching.CDummyCache' : 'CFileCache',
        ),
        // For more info about the emcache, see application/helpers/expressions/em_cache_helper.php.
        // Disabled by default. Enable by adding emcache in config.php after installation.
        'emcache' => array(
            'class' => 'system.caching.CDummyCache'
        ),
        'db' => array(
            'schemaCachingDuration' => 3600,
            'class' => 'DbConnection',
            'enableProfiling' => isset($userConfig['config']['debugsql']) && $userConfig['config']['debugsql'] >= 1,
            'enableParamLogging' => isset($userConfig['config']['debugsql']) && $userConfig['config']['debugsql'] >= 1
        ),
        'session' => array(
            'cookieParams' => array(
                'httponly' => true,
                'secure' => ((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || (isset($_SERVER['SERVER_PORT']) && $_SERVER['SERVER_PORT'] == 443))
            ),
        ),
        'sourceLanguage' => 'en',
        'messages' => array(
            'class' => 'application.core.LSMessageSource',
            'cachingDuration' => 3600,
            'forceTranslation' => true,
            'useMoFile' => true,
            'basePath' => __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'locale'
        ),
        'pluginManager' => array(
            'class' => "\\LimeSurvey\\PluginManager\\PluginManager",
            'api' => "\\LimeSurvey\\PluginManager\\LimesurveyApi"
        ),
        'format' => array(
            'class' => 'application.extensions.CustomFormatter'
        ),
        'LimeMailer' => array(
            /* This allow update LimeMailer in config, but no namespace in this condition … */
            'class' => 'application.core.LimeMailer',
        ),
        'ETwigViewRenderer' => array(
            'class' => 'third_party.yiiext.twig-renderer.ETwigViewRenderer',
            'twigPathAlias' => 'third_party.twig.twig.lib.Twig'
        ),
        'twigRenderer' => array(
            'class' => 'application.core.LSETwigViewRenderer',
            'twigPathAlias' => 'third_party.twig.twig.lib.Twig',

            // All parameters below are optional, change them to your needs
            'fileExtension' => '.twig',
            'options' => array(
                'debug' => defined('YII_DEBUG') && YII_DEBUG ? true : false,
            ),
            'extensions' => array(
                'LS_Twig_Extension',
                'Twig_Extension_Sandbox',
                'Twig_Extension_StringLoader',
                'Twig_Extension_Debug',
                // 'Twig_Extension_Escaper' // In the future, this extenstion could be use to build a powerfull XSS filter
            ),
            'globals' => array(
                'html' => 'CHtml'
            ),
            'functions' => array(
                'getLanguageData'         => 'viewHelper::getLanguageData',
                'array_flip'              => 'array_flip',
                'array_intersect_key'     => 'array_intersect_key',

                /* clientScript */
                'registerPublicCssFile'   => 'LS_Twig_Extension::registerPublicCssFile',
                'registerTemplateCssFile' => 'LS_Twig_Extension::registerTemplateCssFile',
                'registerGeneralScript'   => 'LS_Twig_Extension::registerGeneralScript',
                'registerTemplateScript'  => 'LS_Twig_Extension::registerTemplateScript',
                'registerScript'          => 'LS_Twig_Extension::registerScript',
                'registerPackage'         => 'LS_Twig_Extension::registerPackage',
                'unregisterPackage'       => 'LS_Twig_Extension::unregisterPackage',
                'registerScriptFile'      => 'LS_Twig_Extension::registerScriptFile',
                'registerCssFile'         => 'LS_Twig_Extension::registerCssFile',
                'unregisterScriptFile'    => 'LS_Twig_Extension::unregisterScriptFile',
                'unregisterScriptForAjax' => 'LS_Twig_Extension::unregisterScriptForAjax',
                'listCoreScripts'         => 'LS_Twig_Extension::listCoreScripts',
                'listScriptFiles'         => 'LS_Twig_Extension::listScriptFiles',
                /* String management */
                'processString'           => 'LS_Twig_Extension::processString',
                'flatString'              => 'LS_Twig_Extension::flatString',
                'flattenText'             => 'flattenText', /* Not in 3.X Temporary keep it */
                'ellipsizeString'         => 'LS_Twig_Extension::ellipsizeString',
                'flatEllipsizeText'       => 'LS_Twig_Extension::flatEllipsizeText', /* Temporary keep it */
                'str_replace'             => 'str_replace',
                'strpos'                  => 'strpos',
                'getConfig'               => 'LS_Twig_Extension::getConfig',
                'getExpressionManagerOutput' => 'LS_Twig_Extension::getExpressionManagerOutput',/* Not in 3.X */
                'getTextDisplayWidget'       => 'LS_Twig_Extension::getTextDisplayWidget',/* Not in 3.X */
                'checkPermission'         => 'LS_Twig_Extension::checkPermission',/* Not in 3.X */
                'getAllQuestionClasses'   => 'LS_Twig_Extension::getAllQuestionClasses',
                'getLanguageNameFromCode'    => 'getLanguageNameFromCode',/* Not in 3.X */
                'getLanguageRTL'          => 'LS_Twig_Extension::getLanguageRTL',

                'intval'                  => 'intval',
                'empty'                   => 'empty',
                'count'                   => 'LS_Twig_Extension::safecount',
                'reset'                   => 'reset',
                'in_array'                => 'in_array',
                'in_multiarray'           => 'LS_Twig_Extension::in_multiarray',
                'array_search'            => 'array_search',
                'renderCaptcha'           => 'LS_Twig_Extension::renderCaptcha',
                'getPost'                 => 'LS_Twig_Extension::getPost',
                'getParam'                => 'LS_Twig_Extension::getParam',
                'getQuery'                => 'LS_Twig_Extension::getQuery',
                'isset'                   => 'isset',
                'assetPublish'            => 'LS_Twig_Extension::assetPublish',
                'image'                   => 'LS_Twig_Extension::image',
                'imageSrc'                => 'LS_Twig_Extension::imageSrc',
                'templateResourceUrl'                => 'LS_Twig_Extension::templateResourceUrl',
                'sprintf'                 => 'sprintf',
                'gT'                      => 'gT',
                'ngT'                     => 'ngT',
                'createAbsoluteUrl'       => 'LS_Twig_Extension::createAbsoluteUrl',/* Not in 3.X */
                'createUrl'               => 'LS_Twig_Extension::createUrl',
                'json_decode'             => 'LS_Twig_Extension::json_decode',
                'json_encode'             => 'CJSON::encode',
                'getLanguageNameFromCode' => 'getLanguageNameFromCode',
                'checkconditionFunction'  => 'checkconditionFunction',
                'doRender'                => 'doRender',
                'flattenText'             => 'flattenText',
                'getEditor'               => 'getEditor',
                'darkencss'               => 'LS_Twig_Extension::darkencss',
                'lightencss'              => 'LS_Twig_Extension::lightencss',
                'makeFlashMessage'        => 'makeFlashMessage',
                'getAllTokenAnswers'      => 'LS_Twig_Extension::getAllTokenAnswers',
            ),
            'filters' => array(
                'jencode' => 'CJSON::encode',
                't'     => 'gT',
                'gT'    => 'gT',
            ),

            'sandboxConfig' => array(
                'tags' => array('if', 'for', 'set', 'autoescape', 'block', 'embed', 'use', 'include', 'macro', 'import'),
                'filters' => array(
                    'default',
                    'escape',
                    'raw',
                    't',
                    'merge',
                    'length',
                    'gT',
                    'keys',
                    'date',
                    'format',
                    'nl2br',
                    'split',
                    'trim',
                    'json_encode',
                    'round',
                    'replace',
                    'last',
                    'first',
                    'url_encode',
                    'capitalize',
                    'lower',
                    'upper',
                    'strip_tags',
                    'number_format',
                ),
                'methods' => array(
                    'ETwigViewRendererStaticClassProxy' =>  array("encode", "textfield", "form", "link", "emailField", "beginForm", "endForm", "dropDownList", "htmlButton", "passwordfield", "hiddenfield", "textArea", "checkBox", "tag"),
                    'Survey'                            =>  array("getAllLanguages", "localizedtitle"),
                    'LSHttpRequest'                     =>  array("getParam"),
                    'LSCaptcha'                          =>  array("renderOut"),
                ),
                'properties' =>  array(
                    'ETwigViewRendererYiiCoreStaticClassesProxy' => array("Html"),
                    'LSYii_Application'                          => array("request"),
                    'TemplateConfiguration'             =>  array("sTemplateurl"),
                    'Survey' => array('sid', 'admin', 'active', 'expires', 'startdate', 'anonymized', 'format', 'savetimings', 'template', 'language', 'datestamp', 'usecookie', 'allowprev', 'printanswers', 'showxquestions', 'showgroupinfo', 'shownoanswer', 'showqnumcode', 'showwelcome', 'showprogress', 'questionindex', 'navigationdelay', 'nokeyboard', 'alloweditaftercompletion', 'hasTokensTable', 'hasResponsesTable', 'showsurveypolicynotice', 'aOptions'),
                    'SurveyLanguageSetting' => array('surveyls_description', 'surveyls_welcometext', 'surveyls_endtext', 'surveyls_policy_notice', 'surveyls_policy_error', 'surveyls_policy_notice_label'),
                    'Question' => array('qid', 'parent_qid', 'sid', 'gid', 'type', 'title', 'relevance', 'question', 'help', 'other', 'mandatory', 'language', 'scale_qid'),
                    'QuestionGroups' => array('gid', 'sid', 'group_name', 'group_order', 'description', 'language', 'randomization_group', 'grelevance')
                ),
                'functions' => array(
                    'getLanguageData',
                    'getLanguageRTL',
                    'array_flip',
                    'array_intersect_key',

                    'registerPublicCssFile',
                    'registerTemplateCssFile',
                    'registerGeneralScript',
                    'registerTemplateScript',
                    'registerScript',
                    'registerPackage',
                    'unregisterPackage',
                    'registerCssFile',
                    'registerScriptFile',
                    'unregisterScriptFile',
                    'unregisterScriptForAjax',
                    'listCoreScripts',
                    'listScriptFiles',

                    'processString',
                    'flatEllipsizeText',
                    'flatString',
                    'ellipsizeString',
                    'flatEllipsizeText',
                    'str_replace',
                    'strpos',
                    'flattenText',
                    'getConfig',
                    'getExpressionManagerOutput',
                    'getTextDisplayWidget',
                    'getLanguageNameFromCode',
                    'getAllQuestionClasses',
                    'checkPermission',
                    'intval',
                    'empty',
                    'count',
                    'reset',
                    'in_array',
                    'array_search',
                    'in_multiarray',
                    'renderCaptcha',
                    'getPost',
                    'getParam',
                    'getQuery',
                    'isset',
                    'assetPublish',
                    'image',
                    'imageSrc',
                    'templateResourceUrl',
                    'sprintf',
                    'gT',
                    'ngT',
                    'createAbsoluteUrl',
                    'createUrl',
                    'json_decode',
                    'json_encode',
                    'strip_tags',
                    /* Not in twigRenderer[functions] */
                    'include',
                    'dump',
                    'getLanguageNameFromCode',
                    'checkconditionFunction',
                    'doRender',
                    'flattenText',
                    'range',
                    'getEditor',
                    'darkencss',
                    'lightencss',
                    'getAllTokenAnswers',
                    'makeFlashMessage',
                ),
            ),
        ),
        'extensionUpdaterServiceLocator' => array(
            'class' => '\LimeSurvey\ExtensionInstaller\ExtensionUpdaterServiceLocator',
        ),
        'versionFetcherServiceLocator' => array(
            'class' => '\LimeSurvey\ExtensionInstaller\VersionFetcherServiceLocator',
        ),
    )
);



$result = CMap::mergeArray($internalConfig, $userConfig);
/**
 * Some workarounds for erroneous settings in user config.php.
 * seems not to be used anymore...
 */
$result['defaultController'] = ($result['defaultController'] == 'survey') ? $internalConfig['defaultController'] : $result['defaultController'];
/**
 * Allways add needed routes at end
 */
$result['components']['urlManager']['rules']['<_controller:\w+>/<_action:\w+>'] = '<_controller>/<_action>';

return $result;
/* End of file internal.php */
/* Location: ./application/config/internal.php */
