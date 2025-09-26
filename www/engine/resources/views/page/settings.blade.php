<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Настройки сервиса
</h4>


<p>
    Настройки сервиса хранятся в
    <b>
        /engine/config/postrf.php
    </b>
</p>

<br>
<table class="table">
    <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Параметр</th>
            <th scope="col">Описание</th>
            <th scope="col">Значение</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1</td>
            <td>
                postrf.partner_url
            </td>
            <td>
                Урл обращения к сервису (через тоннель)
            </td>
            <td>
                {{ config('postrf.partner_url', '') }}
            </td>
        </tr>
        <tr>
            <td>2</td>
            <td>
                postrf.request_headers
            </td>
            <td>
                Заголовки для обращения к сервису (специфические)
            </td>
            <td>
                ***************
            </td>
        </tr>
        <tr>
            <td>3</td>
            <td>
                postrf.directory_json
            </td>
            <td>
                Директория с примерами JSON запросов
            </td>
            <td>
                {{ strval(config('postrf.directory_json', '')) }}
            </td>
        </tr>
        <tr>
            <td>4</td>
            <td>
                postrf.directory_json_schema
            </td>
            <td>
                Директория с валидаторами JSON запросов
            </td>
            <td>
                {{ strval(config('postrf.directory_json_schema', '')) }}
            </td>
        </tr>
        <tr>
            <td>5</td>
            <td>
                postrf.directory_html_description
            </td>
            <td>
                Директория с описаниямизапросов
            </td>
            <td>
                {{ strval(config('postrf.directory_html_description', '')) }}
            </td>
        </tr>
        <tr>
            <td>6</td>
            <td>
                postrf.max_log_request_count
            </td>
            <td>
                Максимальное количество логов для хранения
            </td>
            <td>
                {{ intval(config('postrf.max_log_request_count', 0)) }}
            </td>
        </tr>
        <tr>
            <td>7</td>
            <td>
                postrf.log_request_enable
            </td>
            <td>
                Включено логирование запросов
            </td>
            <td>
                {{ intval(config('postrf.log_request_enable', 1)) }}
            </td>
        </tr>
        <tr>
            <td>8</td>
            <td>
                postrf.log_filename
            </td>
            <td>
                Имя файла с логами последних запросов
            </td>
            <td>
                {{ config('postrf.log_filename', '') }}
            </td>
        </tr>
        <tr>
            <td>9</td>
            <td>
                postrf.file_service_url
            </td>
            <td>
                Урл обращения к файловому сервису
            </td>
            <td>
                {{ strval(config('postrf.file_service_url', '')) }}
            </td>
        </tr>
        <tr>
            <td>10</td>
            <td>
                postrf.directory_pdf
            </td>
            <td>
                директория для сожранения PDF файлов для запросов (потому как запуск через консольную утилиту)
            </td>
            <td>
                {{ config('postrf.directory_pdf', '') }}
            </td>
        </tr>
        <tr>
            <td>11</td>
            <td>
                postrf.signers
            </td>
            <td>
                список подписантов, которые могут подписывать запросы к сервису
            </td>
            <td>
                ***************
            </td>
        </tr>

        
    </tbody>
</table>
@endsection
