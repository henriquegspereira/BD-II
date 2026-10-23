<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../src/Repository/LivroRepository.php';

$envPath = __DIR__ . '/../.env';
if (file_exists($envPath)) {
    $variaveis = parse_ini_file($envPath);
    foreach ($variaveis as $chave => $valor) {
        putenv("$chave=$valor");
    }
}

try {
    // 2. Inicia a ligação passando o driver 'mysql'
    $pdo = Database::conectar('mysql');
    
    // 3. Passa a ligação para o repositório
    $repositorio = new LivroRepository($pdo);

    echo "<h1>Biblioteca - Teste de Conexão MySQL</h1>";

    // 4. Lista todos os livros
    echo "<h2>Todos os livros cadastrados:</h2><ul>";
    $livros = $repositorio->listarTodos();
    
    if (empty($livros)) {
        echo "<li>Ainda não há livros cadastrados na base de dados.</li>";
    } else {
        foreach ($livros as $l) {
            echo "<li>{$l->titulo} (R$ {$l->preco})</li>";
        }
    }
    echo "</ul>";

} catch (PDOException $e) {
    echo "<h3>Erro na Base de Dados:</h3>";
    echo "<p>Não foi possível conectar ou recuperar os dados. Tente novamente mais tarde.</p>";
} catch (Error $e) {
    echo "<h3>Erro no Código:</h3>";
    echo "<p>Ocorreu um erro interno na aplicação.</p>";
}