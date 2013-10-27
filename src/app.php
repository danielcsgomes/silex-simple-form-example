<?php

use Igorw\Silex\ConfigServiceProvider;
use Silex\Application;
use Silex\Provider\DoctrineServiceProvider;
use Silex\Provider\FormServiceProvider;
use Silex\Provider\SessionServiceProvider;
use Silex\Provider\TranslationServiceProvider;
use Silex\Provider\TwigServiceProvider;
use Silex\Provider\UrlGeneratorServiceProvider;
use Silex\Provider\ValidatorServiceProvider;
use Silex\Provider\ServiceControllerServiceProvider;

// get environment
$env = strtolower(getenv('APP_ENV'));

$app = new Application();

// load configurations
$app->register(new ConfigServiceProvider(__DIR__ . "/../config/$env.yaml"));
$app->register(new ConfigServiceProvider(__DIR__ . '/../config/database.yaml'));

// register services
$app->register(new UrlGeneratorServiceProvider());
$app->register(new ValidatorServiceProvider());
$app->register(new ServiceControllerServiceProvider());
$app->register(new ValidatorServiceProvider());
$app->register(new SessionServiceProvider());
$app->register(new TranslationServiceProvider(), array('translator.messages' => array()));
$app->register(new FormServiceProvider());
$app->register(new DoctrineServiceProvider(), array($app['dbs.options']));
$app->register(
    new TwigServiceProvider(),
    array(
         'twig.path' => array(__DIR__ . '/../templates'),
         //'twig.options' => array('cache' => __DIR__.'/../var/cache/twig'),
    )
);

$app['twig'] = $app->share($app->extend('twig', function($twig, $app) {
    return $twig;
}));

return $app;
