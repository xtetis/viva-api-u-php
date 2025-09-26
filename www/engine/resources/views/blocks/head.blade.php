<?php
global $checked_init_data;

$page_title = config('api.service_title');
if ($checked_init_data)
{
      $param_value = \App\Models\ApiSqlDataModel::getSettingValue('api_title_short');
      if ($param_value->result > 0) 
      {
          $page_title = $param_value->result_str;
          $page_title = strip_tags($page_title);
      }
}

?><!DOCTYPE html>
<html lang="en">
    <!-- [Head] start -->

    <head>
        <title><?=$page_title;?></title>
        <!-- [Meta] -->
        <meta charset="utf-8">
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
        <meta http-equiv="X-UA-Compatible"
              content="IE=edge">
        <meta name="description"
              content="Datta able is trending dashboard template made using Bootstrap 5 design framework. Datta able is available in Bootstrap, React, CodeIgniter, Angular,  and .net Technologies.">
        <meta name="keywords"
              content="Bootstrap admin template, Dashboard UI Kit, Dashboard Template, Backend Panel, react dashboard, angular dashboard">
        <meta name="author"
              content="Codedthemes">

        <!-- [Favicon] icon -->
        <link rel="icon"
              href="/assets/components/datta-able-theme/assets/images/favicon.svg"
              type="image/x-icon"> <!-- [Font] Family -->
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600&display=swap"
              rel="stylesheet">
        <!-- [Tabler Icons] https://tablericons.com -->
        <link rel="stylesheet"
              href="/assets/components/datta-able-theme/assets/fonts/tabler-icons.min.css">
        <!-- [Feather Icons] https://feathericons.com -->
        <link rel="stylesheet"
              href="/assets/components/datta-able-theme/assets/fonts/feather.css">
        <!-- [Font Awesome Icons] https://fontawesome.com/icons -->
        <link rel="stylesheet"
              href="/assets/components/datta-able-theme/assets/fonts/fontawesome.css">
        <!-- [Material Icons] https://fonts.google.com/icons -->
        <link rel="stylesheet"
              href="/assets/components/datta-able-theme/assets/fonts/material.css">
        <!-- [Template CSS Files] -->
        <link rel="stylesheet"
              href="/assets/components/datta-able-theme/assets/css/style.css"
              id="main-style-link">
        <link rel="stylesheet"
              href="/assets/components/datta-able-theme/assets/css/style-preset.css">


      <link rel="stylesheet"
      href="/assets/css/common.css">


    </head>
    <!-- [Head] end -->
    <!-- [Body] Start -->

    <body data-pc-preset="preset-1"
          data-pc-sidebar-caption="true"
          data-pc-direction="ltr"
          data-pc-theme="light">
