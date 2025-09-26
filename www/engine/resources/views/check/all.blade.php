<!-- Example view file -->
@extends('layouts.app')

@section('page_content')
<h4 class="fw-bold py-3 mb-4">
    Проверка сервиса
</h4>


<?php if (!$check_model->checked_init_data):?>
<!-- alert -->
<div class="alert alert-danger"
     role="alert">
    <div class="d-flex align-items-center">
        <div>
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <div class="ms-3">
            <?= $check_model->getLastErrorMessage()?>
        </div>
    </div>
</div>
<?php else: ?>
<div class="alert alert-success"
     role="alert">
    <div class="d-flex align-items-center">
        <div>
            <i class="fas fa-check-circle"></i>
        </div>
        <div class="ms-3">
            <h5 class="alert-heading">Успех</h5>
            <p>Данные инициализированы</p>
        </div>
    </div>
</div>
<?php endif;?>
<table class="table table-sm table-hover table-striped table-bordered">
    <thead>
        <tr>
            <th>#</th>
            <th>Проверка</th>
            <th>Значение</th>
            <th>Статус проверки</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($check_model->init_check_list as $key => $value): 
        //continue;
        ?>
        <tr <?= (isset($value['hint'])? 'title="'.$value['hint'].'"' : '')?>>
            <td><?=$key?></td>
            <td><?=$value['title']?></td>
            <td>
                <?php  if ($value['show_value']):?>
                <?=json_encode($value['value'], JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE)?>
                <?php  else:?>
                ******
                <?php  endif;?>
            </td>
            <td>
                <?php if ($value['checked']):?>
                <span class="badge bg-success">Успешно</span>
                <?php else: ?>
                    <?php if ($value['prepared']):?>
                        <span class="badge bg-danger">Ошибка</span>
                    <?php else:?>
                        <span class="badge bg-warning">Проверка не проводилась</span>
                    <?php endif;?>
                <?php endif;?>
        </tr>
        <?php endforeach;?>
    </tbody>
</table>
<pre>
<?php 
//print_r($check_model->init_check_list);
?>
</pre>

@endsection
