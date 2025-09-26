<?php
    global $checked_init_data;


?>
<!-- [ Sidebar Menu ] start -->
<nav class="pc-sidebar">
    <div class="navbar-wrapper">
        <div class="m-header">
            <a href="{{ url('/') }}"
               class="b-brand text-primary">
                <!-- ========   Change your logo from here   ============ -->
                <img src="/assets/img/logo/logo.svg"
                     class="img-fluid logo-lg"
                     alt="logo">
            </a>
        </div>
        <div class="navbar-content">
            <ul class="pc-navbar">
                <li class="pc-item">
                    <a href="{{ url('/') }}"
                       class="pc-link">
                        <span class="pc-micon">
                            <i data-feather="home"></i>
                        </span>
                        <span class="pc-mtext">Главная</span>
                    </a>
                </li>
                <li class="pc-item {{ request()->is('check_api') ? 'active' : '' }}">
                    <a href="{{ url('check_api') }}"
                       class="pc-link">
                        <span class="pc-micon"><i data-feather="monitor"></i></span>
                        <span class="pc-mtext">Проверка API</span>
                    </a>
                </li>
                <li class="pc-item {{ request()->is('/migration/sql') ? 'active' : '' }}">
                    <a href="{{ url('/migration/sql') }}"
                       class="pc-link">
                        <span class="pc-micon"><i data-feather="database"></i></span>
                        <span class="pc-mtext">Миграция SQL</span>
                    </a>
                </li>
                <li class="pc-item {{ request()->is(route('apidocs_main')) ? 'active' : '' }}">
                    <a href="{{ url(route('apidocs_main')) }}"
                       class="pc-link">
                        <span class="pc-micon"><i data-feather="book"></i></span>
                        <span class="pc-mtext">Документация API</span>
                    </a>
                </li>
                <?php if ($checked_init_data):?>
                <li class="pc-item {{ request()->is('/test/api') ? 'active' : '' }}">
                    <a href="{{ url('/test/api') }}"
                       class="pc-link">
                        <span class="pc-micon"><i data-feather="droplet"></i></span>
                        <span class="pc-mtext">Тесты API</span>
                    </a>
                </li>
                <li class="pc-item {{ request()->is('logs') ? 'active' : '' }}">
                    <a href="{{ url('/logs') }}"
                       class="pc-link">
                        <span class="pc-micon"><i data-feather="type"></i></span>
                        <span class="pc-mtext">Логи</span>
                    </a>
                </li>
                <li class="pc-item {{ request()->is('settings') ? 'active' : '' }}">
                    <a href="{{ url('/settings') }}"
                       class="pc-link">
                        <span class="pc-micon"><i data-feather="feather"></i></span>
                        <span class="pc-mtext">Настройки</span>
                    </a>
                </li>
                <?php endif; ?>
            </ul>
        </div>
    </div>
</nav>
<!-- [ Sidebar Menu ] end -->
