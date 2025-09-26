<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Документация API
</h4>


<div class="accordion"
     id="accordionExample">
    <div class="accordion-item">
        <h2 class="accordion-header"
            id="headingOne">
            <button class="accordion-button"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#collapseOne"
                    aria-expanded="true"
                    aria-controls="collapseOne">
                Настройки
            </button>
        </h2>
        <div id="collapseOne"
             class="accordion-collapse collapse show"
             aria-labelledby="headingOne"
             data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <div class="container mt-4">
                    <h3>Системные параметры API</h3>

                    <p>
                        Настройки сервиса хранятся в таблицах
                        <b>api.dic_param</b> и
                        <b>api.dic_param_values</b>
                    </p>

                    <div class="row">
                        <div class="col-md-6">
                            <h5>Таблица api.dic_param</h5>
                            <p><strong>Назначение:</strong> Хранение параметров системы.</p>
                            <p><strong>Где используется:</strong> Используется для хранения ключевых параметров
                                конфигурации системы, которые могут быть применены в различных частях приложения.</p>
                            <table class="table table-bordered table-sm">
                                <thead>
                                    <tr>
                                        <th>Поле</th>
                                        <th>Тип данных</th>
                                        <th>Описание</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>param_key</td>
                                        <td>serial4</td>
                                        <td>Первичный ключ</td>
                                    </tr>
                                    <tr>
                                        <td>param_name</td>
                                        <td>varchar</td>
                                        <td>Имя параметра</td>
                                    </tr>
                                    <tr>
                                        <td>param_descr</td>
                                        <td>varchar</td>
                                        <td>Описание параметра</td>
                                    </tr>
                                    <tr>
                                        <td>active</td>
                                        <td>int4</td>
                                        <td>Статус активности (по умолчанию 1)</td>
                                    </tr>
                                    <tr>
                                        <td>created_on</td>
                                        <td>timestamp(6)</td>
                                        <td>Дата и время создания записи (по умолчанию now())</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="col-md-6">
                            <h5>Таблица api.dic_param_values</h5>
                            <p><strong>Назначение:</strong> Хранение значений параметров системы.</p>
                            <p><strong>Где используется:</strong> Используется для хранения конкретных значений
                                параметров, связанных с таблицей <code>dic_param</code>.</p>
                            <table class="table table-bordered table-sm">
                                <thead>
                                    <tr>
                                        <th>Поле</th>
                                        <th>Тип данных</th>
                                        <th>Описание</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>param_value_key</td>
                                        <td>serial4</td>
                                        <td>Первичный ключ</td>
                                    </tr>
                                    <tr>
                                        <td>param_key</td>
                                        <td>int4</td>
                                        <td>Ссылка на параметр (внешний ключ к <code>dic_param</code>)</td>
                                    </tr>
                                    <tr>
                                        <td>param_value</td>
                                        <td>varchar</td>
                                        <td>Значение параметра</td>
                                    </tr>
                                    <tr>
                                        <td>param_category</td>
                                        <td>varchar</td>
                                        <td>Категория параметра (DEV, WORK, PREDRELEASE)</td>
                                    </tr>
                                    <tr>
                                        <td>active</td>
                                        <td>int4</td>
                                        <td>Статус активности (по умолчанию 1)</td>
                                    </tr>
                                    <tr>
                                        <td>created_on</td>
                                        <td>timestamp(6)</td>
                                        <td>Дата и время создания записи</td>
                                    </tr>
                                    <tr>
                                        <td>descr</td>
                                        <td>varchar</td>
                                        <td>Описание значения параметра</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <p>
                        Значение <b>api.dic_param_values.param_category</b> должно быть DEV|PREDRELEASE|WORK
                    </p>

                    <h5>Список доступных параметров</h5>
                    <div class="accordion"
                         id="parametersAccordion">

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading1">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse1">
                                    <strong>api_title_short</strong> - Название сервиса API
                                </button>
                            </h2>
                            <div id="collapse1"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Краткое название сервиса API для отображения в
                                        интерфейсе.</p>
                                    <p><strong>Тип:</strong> string</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span class="badge bg-primary">Тестовый API</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span class="badge bg-success">Тестовый API</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading2">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse2">
                                    <strong>enable_http_base_auth</strong> - Включить ли базовую авторизацию для доступа
                                    к тестовым страницам
                                </button>
                            </h2>
                            <div id="collapse2"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Управление базовой HTTP-авторизацией для доступа к
                                        тестовым страницам API.</p>
                                    <p><strong>Тип:</strong> boolean (0/1)</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span class="badge bg-secondary">0 (отключено)</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span class="badge bg-danger">1 (включено)</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading3">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse3">
                                    <strong>enable_hmac</strong> - Нужен ли HMAC для запросов
                                </button>
                            </h2>
                            <div id="collapse3"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Включение/отключение HMAC-авторизации для входящих
                                        запросов.</p>
                                    <p><strong>Тип:</strong> boolean (0/1)</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span class="badge bg-success">1 (включено)</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span class="badge bg-success">1 (включено)</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading4">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse4">
                                    <strong>show_debug_info</strong> - Отображать отладочную информацию (0/1)
                                </button>
                            </h2>
                            <div id="collapse4"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Включение отладочной информации в ответах API.</p>
                                    <p><strong>Тип:</strong> boolean (0/1)</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span class="badge bg-success">1 (показывать)</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span class="badge bg-danger">0 (скрывать)</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading5">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse5">
                                    <strong>add_in_debug_info_db_connect_data</strong> - Добавлять ли в отладочную
                                    информацию сведения о подключаемых БД
                                </button>
                            </h2>
                            <div id="collapse5"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Включение информации о подключениях к базам данных в
                                        отладочных данных.</p>
                                    <p><strong>Тип:</strong> boolean (0/1)</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span class="badge bg-success">1 (добавлять)</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span class="badge bg-danger">0 (не добавлять)</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading6">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse6">
                                    <strong>log_service_request_body</strong> - Логировать ли тело запроса
                                </button>
                            </h2>
                            <div id="collapse6"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Логирование тела входящих запросов к сервису.</p>
                                    <p><strong>Тип:</strong> boolean (0/1)</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span class="badge bg-success">1 (логировать)</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span class="badge bg-danger">0 (не логировать)</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading7">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse7">
                                    <strong>log_service_post</strong> - Логировать ли массив POST при запросе к сервису
                                </button>
                            </h2>
                            <div id="collapse7"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Логирование POST-параметров запросов к сервису.</p>
                                    <p><strong>Тип:</strong> boolean (0/1)</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span class="badge bg-danger">0 (не логировать)</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span class="badge bg-danger">0 (не логировать)</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading8">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse8">
                                    <strong>api_secret</strong> - Ключ API
                                </button>
                            </h2>
                            <div id="collapse8"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Секретный ключ API для HMAC-авторизации.</p>
                                    <p><strong>Тип:</strong> string (hash)</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span
                                                          class="badge bg-warning text-dark">***************************</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span
                                                          class="badge bg-warning text-dark">***************************</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="accordion-item">
                            <h2 class="accordion-header"
                                id="heading10">
                                <button class="accordion-button collapsed"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse10">
                                    <strong>show_log_fields</strong> - Поля api.request_log, которые отображать в списке
                                    логов
                                </button>
                            </h2>
                            <div id="collapse10"
                                 class="accordion-collapse collapse"
                                 data-bs-parent="#parametersAccordion">
                                <div class="accordion-body">
                                    <p><strong>Назначение:</strong> Настройка отображаемых полей в интерфейсе логов
                                        запросов.</p>
                                    <p><strong>Тип:</strong> JSON array</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>Значения по окружениям:</h6>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>DEV:</span>
                                                    <span
                                                          class="badge bg-secondary">["method_key","request","run_result","run_result_str","service_request_body","service_post","service_request_url","method_name"]</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>WORK:</span>
                                                    <span
                                                          class="badge bg-secondary">["method_key","request","run_result","run_result_str","service_request_body","service_post","service_request_url","method_name"]</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="alert alert-info mt-4"
                         role="alert">
                        <strong>Примечание:</strong> Все параметры имеют статус <code>active = 1</code> и создаются с
                        текущей временной меткой.
                        Значения для категории <code>PREDRELEASE</code> не заданы в текущей конфигурации.
                    </div>
                </div>

            </div>
        </div>
    </div>
    <div class="accordion-item">
        <h2 class="accordion-header"
            id="headingTwo">
            <button class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#collapseTwo"
                    aria-expanded="false"
                    aria-controls="collapseTwo">
                Методы
            </button>
        </h2>
        <div id="collapseTwo"
             class="accordion-collapse collapse"
             aria-labelledby="headingTwo"
             data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <p>
                    Методы сервиса хранятся в таблицах
                    <b>api.methods</b> и
                    <b>api.method_setting</b>
                </p>
            </div>
        </div>
    </div>
    <div class="accordion-item">
        <h2 class="accordion-header"
            id="headingThree">
            <button class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#collapseThree"
                    aria-expanded="false"
                    aria-controls="collapseThree">
                Таблицы
            </button>
        </h2>
        <div id="collapseThree"
             class="accordion-collapse collapse"
             aria-labelledby="headingThree"
             data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <div class="container mt-4">
                    <h2>Описание таблиц базы данных</h2>
                    <p>Ниже приведено описание таблиц базы данных, их назначение и содержимое. Данный блок предназначен
                        для встраивания в документацию и использует стили Bootstrap 5.</p>

                    <h3>1. api.dic_param</h3>
                    <p><strong>Назначение:</strong> Хранение параметров системы.</p>
                    <p><strong>Где используется:</strong> Используется для хранения ключевых параметров конфигурации
                        системы, которые могут быть применены в различных частях приложения.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>param_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>param_name</td>
                                <td>varchar</td>
                                <td>Имя параметра</td>
                            </tr>
                            <tr>
                                <td>param_descr</td>
                                <td>varchar</td>
                                <td>Описание параметра</td>
                            </tr>
                            <tr>
                                <td>active</td>
                                <td>int4</td>
                                <td>Статус активности (по умолчанию 1)</td>
                            </tr>
                            <tr>
                                <td>created_on</td>
                                <td>timestamp(6)</td>
                                <td>Дата и время создания записи (по умолчанию now())</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>2. api.external_connect</h3>
                    <p><strong>Назначение:</strong> Хранение информации о внешних подключениях к базам данных.</p>
                    <p><strong>Где используется:</strong> Используется для управления настройками подключения к внешним
                        базам данных.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>external_connect_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>connect_name</td>
                                <td>varchar</td>
                                <td>Имя подключения (уникальное)</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>3. api.logs</h3>
                    <p><strong>Назначение:</strong> Хранение логов работы системы.</p>
                    <p><strong>Где используется:</strong> Используется для записи сообщений об ошибках, предупреждениях
                        и информационных событиях.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>log_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>message_level</td>
                                <td>varchar</td>
                                <td>Уровень сообщения (ERROR, WARNING, INFO)</td>
                            </tr>
                            <tr>
                                <td>message</td>
                                <td>text</td>
                                <td>Текст сообщения</td>
                            </tr>
                            <tr>
                                <td>function_name</td>
                                <td>varchar</td>
                                <td>Имя функции, вызвавшей лог</td>
                            </tr>
                            <tr>
                                <td>context</td>
                                <td>jsonb</td>
                                <td>Контекст в формате JSON</td>
                            </tr>
                            <tr>
                                <td>error_code</td>
                                <td>varchar</td>
                                <td>Код ошибки</td>
                            </tr>
                            <tr>
                                <td>created_at</td>
                                <td>timestamptz</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>4. api.method_request_func_type</h3>
                    <p><strong>Назначение:</strong> Хранение типов функций для обработки запросов.</p>
                    <p><strong>Где используется:</strong> Используется для классификации функций, выполняемых в рамках
                        обработки запросов API.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>method_request_func_type_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>type_name</td>
                                <td>varchar</td>
                                <td>Имя типа метода (латиницей, уникальное)</td>
                            </tr>
                            <tr>
                                <td>title</td>
                                <td>varchar</td>
                                <td>Описание типа метода</td>
                            </tr>
                            <tr>
                                <td>created_on</td>
                                <td>timestamp</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>5. api.methods</h3>
                    <p><strong>Назначение:</strong> Хранение информации о методах API.</p>
                    <p><strong>Где используется:</strong> Используется для описания доступных методов API, их параметров
                        и настроек.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>method_key</td>
                                <td>int4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>method_name</td>
                                <td>varchar</td>
                                <td>Имя метода (только a-z, 0-9, _)</td>
                            </tr>
                            <tr>
                                <td>title</td>
                                <td>varchar</td>
                                <td>Краткое описание метода</td>
                            </tr>
                            <tr>
                                <td>created_on</td>
                                <td>timestamp</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                            <tr>
                                <td>description</td>
                                <td>varchar</td>
                                <td>Описание метода (пару предложений)</td>
                            </tr>
                            <tr>
                                <td>html_description</td>
                                <td>varchar</td>
                                <td>Описание метода в формате HTML</td>
                            </tr>
                            <tr>
                                <td>request_json_schema</td>
                                <td>varchar</td>
                                <td>JSON-схема для проверки запроса</td>
                            </tr>
                            <tr>
                                <td>require_request_body</td>
                                <td>int4</td>
                                <td>Требуется тело запроса (0 - GET, 1 - POST)</td>
                            </tr>
                            <tr>
                                <td>test_form__show_file_upload_input</td>
                                <td>int4</td>
                                <td>Показывать поле загрузки файла (0/1)</td>
                            </tr>
                            <tr>
                                <td>request_body_must_be_json</td>
                                <td>int4</td>
                                <td>Тело запроса должно быть JSON (0/1)</td>
                            </tr>
                            <tr>
                                <td>response_type</td>
                                <td>varchar</td>
                                <td>Формат ответа (eis или NULL)</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>6. api.dic_param_values</h3>
                    <p><strong>Назначение:</strong> Хранение значений параметров системы.</p>
                    <p><strong>Где используется:</strong> Используется для хранения конкретных значений параметров,
                        связанных с таблицей <code>dic_param</code>.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>param_value_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>param_key</td>
                                <td>int4</td>
                                <td>Ссылка на параметр (внешний ключ к <code>dic_param</code>)</td>
                            </tr>
                            <tr>
                                <td>param_value</td>
                                <td>varchar</td>
                                <td>Значение параметра</td>
                            </tr>
                            <tr>
                                <td>param_category</td>
                                <td>varchar</td>
                                <td>Категория параметра (DEV, WORK, PREDRELEASE)</td>
                            </tr>
                            <tr>
                                <td>active</td>
                                <td>int4</td>
                                <td>Статус активности (по умолчанию 1)</td>
                            </tr>
                            <tr>
                                <td>created_on</td>
                                <td>timestamp(6)</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                            <tr>
                                <td>descr</td>
                                <td>varchar</td>
                                <td>Описание значения параметра</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>7. api.external_connect_params</h3>
                    <p><strong>Назначение:</strong> Хранение параметров подключения к внешним базам данных.</p>
                    <p><strong>Где используется:</strong> Используется для настройки подключений к внешним базам данных,
                        связанным с <code>external_connect</code>.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>external_connect_param_key</td>
                                <td>int4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>created_on</td>
                                <td>timestamp</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                            <tr>
                                <td>db_host</td>
                                <td>varchar</td>
                                <td>Хост подключения</td>
                            </tr>
                            <tr>
                                <td>db_port</td>
                                <td>varchar</td>
                                <td>Порт подключения</td>
                            </tr>
                            <tr>
                                <td>db_username</td>
                                <td>varchar</td>
                                <td>Пользователь для подключения</td>
                            </tr>
                            <tr>
                                <td>db_password</td>
                                <td>varchar</td>
                                <td>Пароль для подключения</td>
                            </tr>
                            <tr>
                                <td>db_database</td>
                                <td>varchar</td>
                                <td>Имя базы данных</td>
                            </tr>
                            <tr>
                                <td>inner_db_type</td>
                                <td>varchar</td>
                                <td>Тип подключения (DEV, WORK)</td>
                            </tr>
                            <tr>
                                <td>external_connect_key</td>
                                <td>int4</td>
                                <td>Ссылка на подключение (внешний ключ к <code>external_connect</code>)</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>8. api.method_example</h3>
                    <p><strong>Назначение:</strong> Хранение примеров запросов для методов API.</p>
                    <p><strong>Где используется:</strong> Используется для предоставления примеров использования методов
                        API.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>method_example_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>method_key</td>
                                <td>int4</td>
                                <td>Ссылка на метод (внешний ключ к <code>methods</code>)</td>
                            </tr>
                            <tr>
                                <td>created_on</td>
                                <td>timestamp</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                            <tr>
                                <td>json_example</td>
                                <td>varchar</td>
                                <td>Тело примера запроса</td>
                            </tr>
                            <tr>
                                <td>example_name</td>
                                <td>varchar</td>
                                <td>Название примера (по умолчанию 'main')</td>
                            </tr>
                            <tr>
                                <td>active</td>
                                <td>int4</td>
                                <td>Статус активности (0/1)</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>9. api.method_request_func</h3>
                    <p><strong>Назначение:</strong> Хранение функций, выполняемых в процессе обработки запросов API.</p>
                    <p><strong>Где используется:</strong> Используется для определения функций, которые вызываются на
                        разных этапах выполнения метода API.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>method_request_func_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>created_on</td>
                                <td>timestamp</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                            <tr>
                                <td>method_request_func_name</td>
                                <td>varchar</td>
                                <td>Имя функции</td>
                            </tr>
                            <tr>
                                <td>method_request_func_type_key</td>
                                <td>int4</td>
                                <td>Тип функции (внешний ключ к <code>method_request_func_type</code>)</td>
                            </tr>
                            <tr>
                                <td>external_connect_key</td>
                                <td>int4</td>
                                <td>Ссылка на подключение (внешний ключ к <code>external_connect</code>, может быть
                                    NULL)</td>
                            </tr>
                            <tr>
                                <td>method_key</td>
                                <td>int4</td>
                                <td>Ссылка на метод (внешний ключ к <code>methods</code>)</td>
                            </tr>
                            <tr>
                                <td>return_as_run_data</td>
                                <td>int4</td>
                                <td>Возвращать результат в run_data (по умолчанию 1)</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>10. api.method_setting</h3>
                    <p><strong>Назначение:</strong> Хранение настроек методов API для разных типов баз данных.</p>
                    <p><strong>Где используется:</strong> Используется для настройки поведения методов API в зависимости
                        от типа базы данных (DEV, WORK, PREDRELEASE).</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>method_setting_key</td>
                                <td>int4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>db_type</td>
                                <td>varchar</td>
                                <td>Тип базы данных (DEV, WORK, PREDRELEASE)</td>
                            </tr>
                            <tr>
                                <td>method_key</td>
                                <td>int4</td>
                                <td>Ссылка на метод (внешний ключ к <code>methods</code>)</td>
                            </tr>
                            <tr>
                                <td>active</td>
                                <td>int4</td>
                                <td>Статус активности метода (0/1)</td>
                            </tr>
                            <tr>
                                <td>log_method_request</td>
                                <td>int4</td>
                                <td>Логировать тело запроса (0/1)</td>
                            </tr>
                            <tr>
                                <td>log_method_response</td>
                                <td>int4</td>
                                <td>Логировать ответ метода (0/1)</td>
                            </tr>
                            <tr>
                                <td>emulate_response</td>
                                <td>int4</td>
                                <td>Эмулировать ответ API (0/1)</td>
                            </tr>
                            <tr>
                                <td>emulate_response_body</td>
                                <td>varchar</td>
                                <td>Эмулированное тело ответа</td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>11. api.request_log</h3>
                    <p><strong>Назначение:</strong> Хранение логов запросов к методам API.</p>
                    <p><strong>Где используется:</strong> Используется для записи информации о выполненных запросах к
                        методам API для последующего анализа.</p>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Поле</th>
                                <th>Тип данных</th>
                                <th>Описание</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>request_log_key</td>
                                <td>serial4</td>
                                <td>Первичный ключ</td>
                            </tr>
                            <tr>
                                <td>create_date</td>
                                <td>timestamp</td>
                                <td>Дата и время создания записи</td>
                            </tr>
                            <tr>
                                <td>method_key</td>
                                <td>int4</td>
                                <td>Ссылка на метод (внешний ключ к <code>methods</code>)</td>
                            </tr>
                            <tr>
                                <td>request</td>
                                <td>varchar</td>
                                <td>Тело запроса</td>
                            </tr>
                            <tr>
                                <td>run_result</td>
                                <td>int4</td>
                                <td>Результат выполнения запроса</td>
                            </tr>
                            <tr>
                                <td>run_result_str</td>
                                <td>varchar</td>
                                <td>Результат выполнения запроса (строка)</td>
                            </tr>
                            <tr>
                                <td>service_request_body</td>
                                <td>varchar</td>
                                <td>Тело запроса к сервису</td>
                            </tr>
                            <tr>
                                <td>service_post</td>
                                <td>varchar</td>
                                <td>POST-параметры в формате JSON</td>
                            </tr>
                            <tr>
                                <td>service_request_url</td>
                                <td>varchar</td>
                                <td>URL запроса к сервису</td>
                            </tr>
                            <tr>
                                <td>method_name</td>
                                <td>varchar</td>
                                <td>Имя метода</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection
