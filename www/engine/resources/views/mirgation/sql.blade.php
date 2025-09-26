<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Списки скриптов для миграции
</h4>

<div>
    Ввиду того, что в БД онраничены права на выполнение скриптов, 
    то сделать миграцию с помощью движка невозможно.
    <br>
    Все скрипты находятся в папке /assets/sql
    и миграцию нужно делать вручную
</div>

<ul>
    <li>
        <div>
            <b>Версия 1:</b>
            <a href="/assets/sql/1.zip" target="_blank">1.zip</a>
        </div>
    </li>
</ul>


@endsection