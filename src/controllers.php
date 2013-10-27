<?php

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

//Request::setTrustedProxies(array('127.0.0.1'));
$app->match(
    '/',
    function (Request $request) use ($app) {
        // some default data for when the form is displayed the first time
        $data = array(
            'name' => 'Your name',
            'twitter_handler' => 'Your twitter handler',
        );

        $form = $app['form.factory']->createBuilder('form', $data)
            ->add('name')
            ->add('twitter_handler')
            ->getForm();

        if ('POST' == $request->getMethod()) {
            $form->bind($request);

            if ($form->isValid()) {
                $data = $form->getData();

                try {
                    $sql = "INSERT INTO `user` (`name`, `twitter_handler`) VALUES (?, ?)";
                    $successful = $app['db']->executeUpdate($sql, array($data['name'], $data['twitter_handler']));

                    if ($successful) {
                        $app['session']->getFlashBag()->add('message', 'Congrats! You are registered.');
                        return $app['twig']->render('success.html.twig');
                    }

                    $app['session']->getFlashBag()->add(
                        'message',
                        '<strong>Username</strong> and <strong>Twitter handler</strong> already exists.'
                    );
                    return $app['twig']->render('form.html.twig', array('form' => $form->createView()));

                } catch (\Exception $e) {
                    $app['session']->getFlashBag()->add(
                        'message',
                        '<strong>Username</strong> & <strong>Twitter handler</strong> already exists.'
                    );

                    return $app['twig']->render('form.html.twig', array('form' => $form->createView()));
                }
            }
        }

        return $app['twig']->render('form.html.twig', array('form' => $form->createView()));
    }
);

$app->error(
    function (\Exception $e, $code) use ($app) {
        if ($app['debug']) {
            return;
        }

        // 404.html, or 40x.html, or 4xx.html, or error.html
        $templates = array(
            'errors/' . $code . '.html',
            'errors/' . substr($code, 0, 2) . 'x.html',
            'errors/' . substr($code, 0, 1) . 'xx.html',
            'errors/default.html',
        );

        return new Response($app['twig']->resolveTemplate($templates)->render(array('code' => $code)), $code);
    }
);
