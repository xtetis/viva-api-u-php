<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Запросы к КБКИ
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
                <i class="tf-icons bx bx-spreadsheet"></i> Форма
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
                <button type="button"
                        id="btn__load_example"
                        url_load="{{ url('load_example') }}"
                        style="float: right; margin-top: -15px;"
                        class="btn btn-warning">Загрузить пример</button>
                <form action="/"
                        id="frm__test_form"
                        target="api"
                      method="post">
                    <div class="mb-3">
                        <label for="exampleFormControlSelect1"
                               class="form-label">Метод</label>
                        <select class="form-select"
                                name="method"
                                id="method"
                                aria-label="Default select example">
                                    <option value="">Не выбран</option>
                                @foreach ($model->getMethodOptions() as $method_name => $method_info)
                                    <option value="{{ $method_name }}">
                                    {{ $method_name }} - {{ $method_info['title'] }}
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
                                  id="request"
                                  rows="7"></textarea>
                        <div class="text-success">
                            $request - POST параметр или тело запроса
                        </div>
                    </div>

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
                Примеры запросов JSON:
                <ul>

                
                @foreach ($directory_json_list as $file)
                    <li>
                        <a href="{{ str_replace($_SERVER['DOCUMENT_ROOT'],'',$file) }}" target="_blank" rel="noopener noreferrer">
                            {{ basename($file) }}
                        </a>
                    </li>
                @endforeach
                </ul>
                <br><br>
                Схемы валидации JSON:
                <ul>
                @foreach ($directory_json_schema_list as $file)
                    <li>
                        <a href="{{ str_replace($_SERVER['DOCUMENT_ROOT'],'',$file) }}" target="_blank" rel="noopener noreferrer">
                            {{ basename($file) }}
                        </a>
                    </li>
                @endforeach
                </ul>
                <br>

                <p>
                    <a target="_blank" href="https://courageous-move-8d2.notion.site/API-Api-Profit-123d3fe3d94e4dbc9f2ad936c3bfb078">    
                        Документация по LeadsTech
                    </a>
                </p>

                <p>
                    <a  target="_blank" href="/assets/pdf/api_harvester_project.pdf">    
                        Документация по Ryabina
                    </a>
                </p>


                <br>
                Диретории:
                <ul>
                    <li>
                    Директория с примерами JSON запросов - 
                    <b>
                        {{ $directory_json }}
                    </b>
                    </li>
                    <li>
                    Директория с валидаторами JSON запросов - 
                    <b>
                        {{ $directory_json_schema }}
                    </b>
                    </li>
                </ul>
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
                <p>
                    Доступен отладочный режим - POST параметр debug.
                    Допустимые значения:
                    <ol>
                        <li>return__qcb_putanswer - Возвращать qcb_putanswer.xml</li>
                    </ol>
                </p>

                <br>
                <p>
                    Нюансы для запроса <b>dlrequest</b>:
                    <ol>
                        <li>
                            Дата выдачи согласия должна быть ранее даты выдачи займа
                        </li>
                        <li>
                            Дата контракта должны быть больше даты запроса
                        </li>
                    </ol>
                </p>
                <br>
                <p>
                    Настройки сервиса хранятся в 
                    <b>
                        /engine/config/kbki.php
                    </b>
                </p>
            </p>
        </div>
    </div>
</div>
@endsection