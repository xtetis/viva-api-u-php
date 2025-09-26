// Примеры для текущего метода
var current_method_examples;

function showMessage(message, type = 'success') {
    // Удаляем все классы
    $('#container_show_message')
        .removeClass();
    // Добавляем нужный класс
    $('#container_show_message')
        .addClass('alert alert-' + type);

    $('#container_show_message')
        .html(message);

    $("#container_show_message")
        .fadeIn('slow');

    setTimeout(function () {
        $("#container_show_message")
            .fadeOut('slow');
    }, 4000);

}


$(function () {
    $('body').on('click', '.load_example_btn_item', function() {
        var method_example_key = $(this).attr('method_example_key');
        //
        console.log(current_method_examples);
        
        for (var key in current_method_examples) {
            if (current_method_examples.hasOwnProperty(key)) {
                if (current_method_examples[key] != null) {
                    if (current_method_examples[key].method_example_key == method_example_key) {
                        $('#request').val(current_method_examples[key].json_example);
                        $('#request').trigger('change');
                        break;
                    }
                }
            }
        }
    });

    $('#method').on('change', function () {
        var method = $(this).val();
        var url_load = $(this).attr('url_ajax_load_method_settings');

        current_method_examples = null;
        $('#current_method_examples_dropdown').empty();
        $('.ajax_data__current_method').hide();
        $('.test_form__show_file_upload_input__container').hide();
        $('#btn__load_example').hide();
        $('#frm__test_form').attr('action', '/');
        $('#request').val('');

        // Выполняем POST запрос. В случае ошибки при HTTP запросе вызываем .on('error')
        $.post(url_load,
            {
                method: method
            }
        )
        .done(function(data){ 
            //var data = JSON.parse(msg);
            console.log(data);
            
            // Проверяем наличие в data (это объект) нод result и result_str
            // Иначе сообщение чтоответ имеет некорректную структуру
            if (data.hasOwnProperty('result') && data.hasOwnProperty('result_str')) {
                if (!data.result) {
                    showMessage(data.result_str, 'danger');
                    return true;
                }

                // Убираем из текущего SELECT тот Option, который не содержит value
                // Это тот который первый и пустой
                $('#method option[value=""]').remove();

                $('#btn__load_example').show();

                $('.methon_name').html(method);

                if (data.run_data.current_method.test_form__show_file_upload_input)
                {
                    $('.test_form__show_file_upload_input__container').show();
                }

                $('#frm__test_form').attr('action', '/api/' + method);
                

                // Для каждого ключа в data.run_data.current_method
                // Добавляем значение в соответствующий элемент на странице
                // Иначе сообщение чтоответ имеет некорректную структуру
                for (var key in data.run_data.current_method) {
                    if (data.run_data.current_method.hasOwnProperty(key)) {
                        if (data.run_data.current_method[key] != null) {
                            $('.ajax_data__current_method__'+key).html(data.run_data.current_method[key]);
                            $('.ajax_data__current_method__'+key).show();
                        }
                    }
                }

                current_method_examples = data.run_data.current_method_examples;
                console.log(current_method_examples);
                /*
                for (var key in data.run_data.current_method_examples) {
                    if (data.run_data.current_method_examples.hasOwnProperty(key)) {
                        if (data.run_data.current_method_examples[key] != null) {
                            $('#current_method_examples_dropdown').append('<li><a onclick="return false;" class="dropdown-item load_example_btn_item" href="#" method_example_key="'+data.run_data.current_method_examples[key].method_example_key+'" json_example="'+data.run_data.current_method_examples[key].json_example+'">'+data.run_data.current_method_examples[key].example_name+'</a></li>');
                        }
                    }
                }
                */
                for (var key in current_method_examples) {
                    if (current_method_examples.hasOwnProperty(key)) {
                        if (current_method_examples[key] != null) {
                            $('#current_method_examples_dropdown').append('<li><a onclick="return false;" class="dropdown-item load_example_btn_item" href="#" method_example_key="'+current_method_examples[key].method_example_key+'">'+current_method_examples[key].example_name+'</a></li>');
                        }
                    }
                }
                
            }
            else
            {
                showMessage('Ошибка при загрузке настроек для метода '+method+' ('+url_load+'): некорректная структура ответа', 'danger');
                return true;
            }

            
            
            
         })
        .fail(function(xhr, status, error) {
            // error handling
            showMessage('Ошибка при загрузке настроек для метода '+method+' ('+url_load+'): '+error, 'danger');
        });;
    });


    $('#request').on('change', function () {
        var request = $(this).val();
        
        request = request.replace(/%0A/g, '%0D%0A');

        var method = $('#method').val();
        var url_load = $(this).attr('url_ajax_get_hmac');
        $('#hmac').val('');

        // Выполняем POST запрос. В случае ошибки при HTTP запросе вызываем .on('error')
        $.post(url_load,
            {
                request: request
            }
        )
        .done(function(data){ 
            //var data = JSON.parse(msg);
            console.log(data);
            
            // Проверяем наличие в data (это объект) нод result и result_str
            // Иначе сообщение чтоответ имеет некорректную структуру
            if (data.hasOwnProperty('result') && data.hasOwnProperty('result_str')) {
                if (!data.result) {
                    showMessage(data.result_str, 'danger');
                    return true;
                }

                $('#hmac').val(data.result_str);
                $('#request').val(data.request);
            }
            else
            {
                showMessage('Ошибка при получении HMAC для запроса: ('+url_load+'): некорректная структура ответа', 'danger');
                return true;
            }
            
         })
        .fail(function(xhr, status, error) {
            // error handling
            showMessage('Ошибка при hmac для запроса: '+error, 'danger');
        });;
    });

    // При отпускании клавиши в #request
    $('#request').on('keyup', function (e) {
        //$('#request').trigger('change');
    });
    
    //$('#request').trigger('change');
});