<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Логи запросов
</h4>

<?php $counter = 0; ?>

<br>
<table class="table">
    <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Дата/время</th>
            <th scope="col">Метод</th>
            <th scope="col">Подробности</th>
        </tr>
    </thead>
    <tbody>
        @foreach (array_reverse($model->getLogs()) as $log_item)
        <tr class="{{ intval($log_item['is_error'])? 'table-danger' : '' }}">
            <td><?=$counter++?></td>
            <td>
                {{ $log_item['request_date'] }}
            </td>
            <td>
                {{ $log_item['method'] }}
            </td>
            <td>
                <div>
                    Таймаут запроса: {{ $log_item['request_timeout'] }}
                </div>
                <div>
                    Ошибка: {{ intval($log_item['is_error']) }}
                </div>
                <div>
                    Текст ошибки: {{ $log_item['error_message'] }}
                </div>
                <div>
                    Урл запроса: {{ $log_item['url_request'] }}
                </div>
                <div>
                    Тело запроса:
                    <a class="btn btn-primary btn-sm"
                       data-bs-toggle="collapse"
                       href="#collapse_request_<?=$counter?>"
                       role="button"
                       aria-expanded="false"
                       aria-controls="collapse_request_<?=$counter?>">
                        Скрыть/показать
                    </a>
                </div>
                <div>
                    Тело ответа:
                    <a class="btn btn-primary btn-sm"
                       data-bs-toggle="collapse"
                       href="#collapse_response_<?=$counter?>"
                       role="button"
                       aria-expanded="false"
                       aria-controls="collapse_response_<?=$counter?>">
                        Скрыть/показать
                    </a>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <div class="collapse"
                     id="collapse_request_<?=$counter?>">
                    <div class="card card-body">
<div>
    Тело запроса:
</div>
<pre>
{{ $log_item['request'] }}
</pre>
                    </div>
                </div>
                <div class="collapse"
                     id="collapse_response_<?=$counter?>">
                    <div class="card card-body">
<div>
    Тело ответа:
</div>
<div style="    max-width: 800px;
    overflow-x: scroll;">
    
    {{ strval($log_item['partner_response']) }}
    
</div>

                    </div>
                </div>
            </td>
        </tr>

        @endforeach
    </tbody>
</table>
@endsection
