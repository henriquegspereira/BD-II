CREATE TABLE autor (
    id SERIAL,
    nome VARCHAR(150) NOT NULL,
    nacionalidade VARCHAR(80),
    CONSTRAINT pk_autor PRIMARY KEY (id)
);

CREATE TABLE livro (
    id SERIAL,
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