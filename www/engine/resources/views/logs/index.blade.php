<?php

$show_log_fields = $params['show_log_fields'];
$show_log_fields = json_decode($show_log_fields,true);

$hidden_fields = [
    'request',
    'run_result',
    'run_result_str',
    'service_request_body',
    'service_response_body',
    'service_post',
    'method_key',
]

?>

<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Логи API
</h4>

<table class="table table-striped table-hover table-sm table-bordered">
    <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Дата/время</th>
            <th scope="col">Урл</th>
            <th scope="col">Метод</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($request_log_list as $item):?>
        <tr>
            <td>
                <?=$item['request_log_key']?>
            </td>
            <td>
                <?=$item['create_date']?>
            </td>
            <td>
                <?=$item['service_request_url']?>
            </td>
            <td>
                <?=$item['method_name']?>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <div class="btn-group" role="group" aria-label="Basic example">
                <?php foreach ($hidden_fields as $hidden_field):?>
                <?php if (in_array($hidden_field, $show_log_fields)):?>
                    <a href="javascript:void(0);"
                       onclick="$('.collapse').hide(); $('#collapse_<?=$hidden_field?>_<?=$item['request_log_key']?>').show();return false;"
                       class="btn btn-secondary">
                        <?=$hidden_field?>
                    </a>
                <?php endif;?>
                <?php endforeach;?>
                </div>


                <?php foreach ($hidden_fields as $hidden_field):?>
                <?php if (in_array($hidden_field, $show_log_fields)):?>
                <div class="collapse"
                     id="collapse_<?=$hidden_field?>_<?=$item['request_log_key']?>">
                    <div>
                        <b><?=$hidden_field?></b>
                    </div>
                    <div class="card card-body" style="    padding: 0;
    margin: 0;">
                        <pre style="    overflow-x: scroll;
    width: 600px;
    min-width: 100%;
    margin: 0;"><?=$item[$hidden_field]?></pre>
                    </div>
                </div>
                <?php endif;?>
                <?php endforeach;?>

            </td>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>

<pre>
<?php
//print_r($request_log_list);
?>

<?php
//print_r($show_log_fields);
?>
</pre>

@endsection
