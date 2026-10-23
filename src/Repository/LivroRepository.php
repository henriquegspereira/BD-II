<?php
require_once __DIR__ . '/../Model/Livro.php';

final class LivroRepository
{
    public function __construct(private PDO $pdo) {}

    public function listarTodos(): array
    {
        $stmt = $this->pdo->query('SELECT id, titulo, preco FROM livro ORDER BY titulo');
        $livros = [];
        while ($row = $stmt->fetch()) {
            $livros[] = new Livro((int)$row['id'], $row['titulo'], (float)$row['preco']);
        }
        return $livros;
    }

    public function buscarPorId(int $id): ?Livro
    {
        $stmt = $this->pdo->prepare('SELECT id, titulo, preco FROM livro WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        
        if ($row === false) return null;
        
        return new Livro((int)$row['id'], $row['titulo'], (float)$row['preco']);
    }

    public function cadastrar(string $titulo, string $isbn, int $ano, float $preco, int $qtd, ?int $idAutor): void
    {
        $sql = 'INSERT INTO livro (titulo, isbn, ano_publicacao, preco, quantidade, id_autor) 
                VALUES (:titulo, :isbn, :ano, :preco, :qtd, :autor)';
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            'titulo' => $titulo, 'isbn' => $isbn, 'ano' => $ano, 
            'preco' => $preco, 'qtd' => $qtd, 'autor' => $idAutor
        ]);
    }
}