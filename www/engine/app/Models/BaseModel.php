<?php

namespace App\Models;



class BaseModel
{
    /**
     * Список ошибок
     */
    public $errors = [];

    /**
     * Добавляет ошибку в список
     */
    public function addError(string $field, string $error): void
    {
        $this->errors[$field] = $error;
    }

    /**
     * Проверить наличие ошибок
     *
     * @return bool
     */
    public function hasErrors(): bool
    {
        return !empty($this->errors);
    }

    /**
     * Получить список ошибок
     *
     * @return array
     */
    public function getErrors(): array
    {
        return $this->errors;
    }

    /**
     * Очистить список ошибок
     *
     * @return void
     */
    public function clearErrors(): void
    {
        $this->errors = [];
    }

    /**
     * Получить последнее сообщение об ошибке с категорией поля
     *
     * @return string
     */
    public function getLastErrorMessage(): string
    {
        return end($this->errors) ?: '';
    }

    /**
     * Получить количество ошибок
     *
     * @return int
     */
    public function getErrorCount(): int
    {
        return count($this->errors);
    }

    /**
     * Получить все сообщения об ошибках в виде строки
     *
     * @return string
     */
    public function getErrorMessages(): string
    {
        return implode(', ', $this->errors);
    }
}
