<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Тесты API
</h4>


<div class="nav-align-top mb-4">
    <ul class="nav nav-pills mb-3 nav-fill"
        role="tablist">
        <li class="nav-item">
            <button type="button"
                    class="nav-link active"
                    role="tab"
                    data-bs-toggle="tab"
                    data-bs-target="#navs-pills-justified-home"
                    aria-controls="navs-pills-justified-home"
                    aria-selected="true">
                <i class="tf-icons bx bx-spreadsheet"></i> Тестовая форма
            </button>
        </li>
        <li class="nav-item">
            <button type="button"
                    class="nav-link"
                    role="tab"
                    data-bs-toggle="tab"
                    data-bs-target="#navs-pills-justified-profile"
                    aria-controls="navs-pills-justified-profile"
                    aria-selected="false">
                <i class="tf-icons bx bx-text"></i> Описание
            </button>
        </li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade active show"
             id="navs-pills-justified-home"
             role="tabpanel">
            <div>

                <div class="dropdown" id="btn__load_example" style="display: none;">
                    <button class="btn btn-warning dropdown-toggle"
                            style="float: right; margin-top: -15px;"
                            type="button"
                            id="dropdownMenuButton1"
                            data-bs-toggle="dropdown"
                            aria-expanded="false">
                        Загрузить пример
                    </button>
                    <ul class="dropdown-menu" id="current_method_examples_dropdown"
                        aria-labelledby="dropdownMenuButton1">
                    </ul>
                </div>

                <form action="/"
                      id="frm__test_form"
                      enctype="multipart/form-data"
                      target="api"
                      method="post">
                    <div>
                        <h5>Адрес запроса
                            <span class="badge bg-success">
                                https://<?=$_SERVER['HTTP_HOST']?>/api/<span
                                      class="methon_name">METHOD_NAME</span></span>
                        </h5>
                    </div>

                    <div class="mb-3">
                        <label for="exampleFormControlSelect1"
                               class="form-label">Метод</label>
                        <select class="form-select"
                                url_ajax_load_method_settings="{{ url(route('test.ajax_load_method_settings')) }}"
                                name="method"
                                id="method"
                                aria-label="Default select example">
                            <option value="">Не выбран</option>
                            @foreach ($method_list_options as $method_name => $method_title)
                            <option value="{{ $method_name }}">
                                {{ $method_name }} - {{ $method_title }}
                            </option>
                            @endforeach
                        </select>
                        <div class="text-success">
                            $method - часть урла /api/<span class="methon_name">METHOD_NAME</span>
                        </div>
                    </div>

                    <div>
                        <label for="exampleFormControlTextarea1"
                               class="form-label">Тело запроса</label>
                        <textarea class="form-control"
                                  name="request"
                                  url_ajax_get_hmac="{{ url(route('test.ajax_get_hmac')) }}"
                                  id="request"
                                  rows="7"></textarea>
                        <div class="text-success">
                            $request - POST параметр "request" или тело запроса
                        </div>
                    </div>
                    <!-- Если test_form__show_file_upload_input = 1 то показываем инпут с файлом -->
                    <div class="test_form__show_file_upload_input__container" style="display: none;">
                        <br>

                        <div>
                            <label for="exampleFormControlSelect1"
                                   class="form-label">Файл</label>
                            <input type="file"
                                   name="file"
                                   id="">
                            <div class="text-success">
                                $file - файл, переданный как multipart/form-data с именем file
                            </div>
                        </div>
                    </div>

                    @if ($params['enable_hmac'] == 1)
                    <div>
                        <label for="exampleFormControlInput1"
                               class="form-label">HMAC</label>
                        <input type="text"
                               readonly="readonly"
                               class="form-control"
                               name="hmac"
                               id="hmac"
                               placeholder="HMAC">
                        <div class="text-success">
                            $hmac - POST параметр "hmac". Рассчитывается как MD5(REQUEST, SECRET), где REQUEST - тело запроса, а SECRET - ключ API
                        </div>
                    </div>
                    @endif

                    <br>
                    <button type="submit"
                            class="btn btn-primary">Отправить</button>
                </form>
            </div>
        </div>
        <div class="tab-pane fade"
             id="navs-pills-justified-profile"
             role="tabpanel">
            <p>
            <h3>Заголовок метода</h3>
            <div class="ajax_data__current_method ajax_data__current_method__title"></div>
            <br>
            <h3>Имя метода</h3>
            <div class="ajax_data__current_method ajax_data__current_method__method_name"></div>
            <br>
            <h3>Описание метода</h3>
            <div class="ajax_data__current_method ajax_data__current_method__description"></div>
            <br>
            <h3>Краткое описание метода</h3>
            <div class="ajax_data__current_method ajax_data__current_method__description"></div>
            <br>
            <h3>Описание метода</h3>
            <div class="ajax_data__current_method ajax_data__current_method__html_description"></div>
            <br>
            <h3>Требует ли метод тело запроса</h3>
            <div class="ajax_data__current_method ajax_data__current_method__require_request_body"></div>
            <br>
            <h3>Нужно ли для метода на тестовой форме отображать инпут с файлом</h3>
            <div class="ajax_data__current_method ajax_data__current_method__test_form__show_file_upload_input"></div>
            <br>
            <h3>JSON схема для валидации тела запроса</h3>
            <div class="ajax_data__current_method ajax_data__current_method__request_json_schema"></div>
            <br>

            <br>


            Запрос можно строить двумя вариантами:
            <ol>
                <li>
                    Отправка запроса в корень сервиса
                    <b>
                        https://{{ $_SERVER['HTTP_HOST'] }}/
                    </b>, при этом поля
                    <b>method</b> и <b>request</b> отправляются как POST параметры
                </li>
                <li>
                    Отправка запроса по адресу
                    <b>/api/{method}</b>,
                    где <b>{method}</b> - имя метода, а
                    <b>request</b> - обычный POST параметр
                </li>
                <li>
                    Отправка запроса по адресу
                    <b>/api/{method}</b>,
                    где <b>{method}</b> - имя метода, а
                    <b>request</b> - тело запроса
                </li>
            </ol>
            <br>
            <p>
                Настройки сервиса хранятся в
                <b>
                    /engine/config/service.php
                </b>
            </p>
            <p>
            <ul>
                <li>
                    <b>partner_url</b> - Урл обращения к сервису (через тоннель)
                </li>
                <li>
                    <b>authorization</b> - Заголовки для обращения к сервису
                </li>
                <li>
                    <b>directory_json</b> - Директория с примерами JSON запросов
                </li>
                <li>
                    <b>directory_json_schema</b> - Директория с валидаторами JSON запросов
                </li>
                <li>
                    <b>directory_html_description</b> - Директория с описаниями запросов
                </li>
                <li>
                    <b>max_log_request_count</b> - Максимальное количество логов для хранения
                </li>
                <li>
                    <b>log_request_enable</b> - Включение логирования запросов
                </li>
                <li>
                    <b>log_filename</b> - Путь сохранения логов
                </li>
            </ul>
            </p>




            </p>
        </div>
    </div>
</div>
@endsection
