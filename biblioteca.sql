-- =========================================================================
-- ATIVIDADE PRÁTICA: SISTEMA DE CONTROLE DE BIBLIOTECA
-- =========================================================================
-- Componente: Banco de Dados II
-- Professor: Leandro Otavio Cordova Vieira
-- Aluno: Henrique Gabriel da Silva Pereira - 445406
-- =========================================================================

-- 01. Criar e selecionar o banco de dados

CREATE DATABASE IF NOT EXISTS biblioteca;

USE biblioteca;



-- 02 e 03 e 04. Criar as tabelas 'autor' e 'livro' com constraints
-- (PRIMARY KEY, AUTO_INCREMENT, NOT NULL e UNIQUE para o ISBN)

CREATE TABLE IF NOT EXISTS autor (
    id INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    nacionalidade VARCHAR(80),
    CONSTRAINT pk_autor PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS livro (
    id INT AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    ano_publicacao INT,
    preco DECIMAL(10,2),
    quantidade INT NOT NULL,
    id_autor INT,
    CONSTRAINT pk_livro PRIMARY KEY (id),
    CONSTRAINT uk_livro_isbn UNIQUE (isbn),
    CONSTRAINT fk_livro_autor FOREIGN KEY (id_autor) REFERENCES autor(id)
);


-- 05. Inserir pelo menos 5 autores e 10 livros

-- Inserindo Autores
INSERT INTO autor (nome, nacionalidade) VALUES
('Machado de Assis', 'Brasileira'),
('J.K. Rowling', 'Britânica'),
('George Orwell', 'Britânica'),
('J.R.R. Tolkien', 'Britânica'),
('Clarice Lispector', 'Brasileira');

-- Inserindo Livros (relacionados aos autores cadastrados via id_autor)
INSERT INTO livro (titulo, isbn, ano_publicacao, preco, quantidade, id_autor) VALUES
('Dom Casmurro', '9788508154159', 1899, 49.90, 5, 1),
('Memórias Póstumas de Brás Cubas', '9788535902556', 1881, 45.00, 3, 1),
('Harry Potter e a Pedra Filosofal', '9788532511010', 1997, 59.90, 10, 2),
('Harry Potter e a Câmara Secreta', '9788532512062', 1998, 62.90, 8, 2),
('1984', '9788535914849', 1949, 39.90, 12, 3),
('A Revolução dos Bichos', '9788535909555', 1945, 29.90, 15, 3),
('O Senhor dos Anéis: A Sociedade do Anel', '9788533613379', 1954, 79.90, 6, 4),
('O Hobbit', '9788533615588', 1937, 49.90, 9, 4),
('A Hora da Estrela', '9788532530806', 1977, 35.00, 4, 5),
('Perto do Coração Selvagem', '9788532529206', 1943, 42.00, 7, 5);


-- 06. Consultar, atualizar e excluir dados (DQL, DML)

-- A) Consultar todos os livros cadastrados
SELECT * FROM livro;

-- B) Consultar livros publicados após o ano de 1950
SELECT * FROM livro WHERE ano_publicacao > 1950;

-- C) Consultar livros filtrando por padrão de texto (LIKE)
SELECT * FROM livro WHERE titulo LIKE '%Harry%';

-- D) Consulta de segurança antes do UPDATE
SELECT * FROM livro WHERE id = 1;

-- E) Atualizar o preço de um livro específico
UPDATE livro 
SET preco = 54.90 
WHERE id = 1;

-- F) Consulta de segurança antes do DELETE
SELECT * FROM livro WHERE id = 10;

-- G) Excluir um registro específico
DELETE FROM livro WHERE id = 10;

-- H) Verificação final do estado das tabelas
SELECT * FROM autor;
SELECT * FROM livro;

-- =========================================================================
-- PARTE 01: SELEÇÃO, FILTROS, ORDENAÇÃO E CONTAGENS (Exercícios 1 a 4)
-- =========================================================================
USE biblioteca;

-- -------------------------------------------------------------------------
-- Exercício 01: Livros com preço superior a R$ 80,00, do mais caro ao mais barato
-- -------------------------------------------------------------------------
SELECT titulo, ano_publicacao, preco
FROM livro
WHERE preco < 40.00
ORDER BY preco DESC;

-- -------------------------------------------------------------------------
-- Exercício 02: Três livros mais recentes com preço entre R$ 50,00 e R$ 150,00
-- -------------------------------------------------------------------------
SELECT titulo, ano_publicacao, preco
FROM livro
WHERE preco BETWEEN 50.00 AND 150.00
ORDER BY ano_publicacao DESC, titulo ASC
LIMIT 3;

-- -------------------------------------------------------------------------
-- Exercício 03: Anos de publicação distintos, excluindo nulos, do mais antigo ao mais recente
-- -------------------------------------------------------------------------
SELECT DISTINCT ano_publicacao
FROM livro
WHERE ano_publicacao IS NOT NULL
ORDER BY ano_publicacao ASC;

-- -------------------------------------------------------------------------
-- Exercício 04: Consultas de contagem (Diferença entre COUNT(*) e COUNT(coluna))
-- -------------------------------------------------------------------------
-- A) Conta todas as linhas da tabela (inclui nulos)
SELECT COUNT(*) AS total_livros 
FROM livro;

-- B) Conta apenas os registos onde a coluna ano_publicacao não é nula
SELECT COUNT(ano_publicacao) AS anos_informados 
FROM livro;

-- C) Conta os anos distintos e não nulos presentes na tabela
SELECT COUNT(DISTINCT ano_publicacao) AS anos_distintos 
FROM livro;

-- =========================================================================
-- PARTE 02: AGREGAÇÕES E AGRUPAMENTOS (Exercícios 5 a 8)
-- =========================================================================
USE biblioteca;

-- -------------------------------------------------------------------------
-- Exercício 05: Total de exemplares e valor financeiro total estimado do estoque
-- -------------------------------------------------------------------------
SELECT 
    SUM(quantidade) AS total_exemplares,
    SUM(preco * quantidade) AS valor_total_estoque
FROM livro;

-- -------------------------------------------------------------------------
-- Exercício 06: Preço médio (com 2 casas decimais), menor e maior preço
-- -------------------------------------------------------------------------
SELECT 
    ROUND(AVG(preco), 2) AS preco_medio,
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM livro;

-- -------------------------------------------------------------------------
-- Exercício 07: Quantidade de títulos e total de exemplares por ano de publicação
-- -------------------------------------------------------------------------
SELECT 
    ano_publicacao,
    COUNT(*) AS total_titulos,
    SUM(quantidade) AS total_exemplares
FROM livro
GROUP BY ano_publicacao
ORDER BY ano_publicacao ASC;

-- -------------------------------------------------------------------------
-- Exercício 08: Relatório filtrando anos com pelo menos dois títulos (uso do HAVING)
-- -------------------------------------------------------------------------
-- O HAVING é apropriado porque filtra os grupos *após* a agregação do COUNT.

UPDATE livro SET ano_publicacao = 1997 WHERE id IN (1, 2);
UPDATE livro SET ano_publicacao = 1998 WHERE id IN (3, 4);

SELECT 
    ano_publicacao,
    COUNT(*) AS total_titulos,
    SUM(quantidade) AS total_exemplares
FROM livro
GROUP BY ano_publicacao
HAVING COUNT(*) >= 2
ORDER BY ano_publicacao ASC;

-- =========================================================================
-- PARTE 03: FUNÇÕES ESCALARES E DESAFIO INTEGRADOR (Exercícios 9 e 10)
-- =========================================================================
USE biblioteca;

-- -------------------------------------------------------------------------
-- Exercício 09: Título original, em maiúsculas, número de caracteres e reajuste de 8%
-- -------------------------------------------------------------------------
SELECT 
    titulo,
    UPPER(titulo) AS titulo_maiusculo,
    CHAR_LENGTH(titulo) AS numero_caracteres,
    preco AS preco_original,
    ROUND(preco * 1.08, 2) AS preco_reajustado_8porcento
FROM livro;

-- -------------------------------------------------------------------------
-- Exercício 10: Desafio Integrador por ano (títulos, preço médio e valor do estoque)
-- Restrições: quantidade positiva, pelo menos dois títulos por ano, ordenado por maior valor
-- -------------------------------------------------------------------------
SELECT 
    ano_publicacao,
    COUNT(*) AS total_titulos,
    ROUND(AVG(preco), 2) AS preco_medio,
    SUM(preco * quantidade) AS valor_total_estoque
FROM livro
WHERE quantidade > 0
GROUP BY ano_publicacao
HAVING COUNT(*) >= 2
ORDER BY valor_total_estoque DESC;