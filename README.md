# Projeto Biblioteca - PHP e MySQL

**1. O PDO é um ORM?**
Não. O PDO (PHP Data Objects) é apenas uma interface segura para aceder à base de dados. Ele executa comandos SQL, mas não mapeia tabelas para objetos automaticamente como faz um ORM verdadeiro (ex: Doctrine ou Hibernate).

**2. O padrão Repository dispensa o uso de SQL?**
Não. O Repository serve apenas para organizar o código e centralizar o acesso aos dados. As consultas em linguagem SQL continuam a ser escritas manualmente dentro dos métodos do repositório.

**3. Por que usar prepared statements?**
Principalmente por segurança, para evitar ataques de *SQL Injection*. Os *prepared statements* (como o `prepare` e `execute`) enviam os dados do utilizador separados da estrutura do comando SQL, impedindo que código malicioso seja interpretado pela base de dados.

**4. Quais as principais diferenças na criação das tabelas entre MySQL e PostgreSQL?**
A principal diferença aplicada neste projeto refere-se à criação de chaves primárias com auto-incremento. No MySQL, utilizamos o atributo `AUTO_INCREMENT` num campo do tipo `INT`. No PostgreSQL, utilizamos o pseudo-tipo `SERIAL`, que por baixo dos panos cria automaticamente um objeto de sequência (sequence) e atribui o próximo valor dessa sequência ao campo. Além disso, o uso da cláusula `IF NOT EXISTS` na criação de tabelas é nativo e muito comum no MySQL, enquanto no PostgreSQL exige versões mais recentes para funcionar da mesma forma.

**5. Como a mesma consulta se comporta nos dois SGBDs (MySQL vs PostgreSQL)?**
Consultas simples de CRUD (como `SELECT * FROM livro WHERE id = :id`) comportam-se de forma idêntica em ambos os SGBDs, pois utilizam o padrão ANSI SQL que o PDO executa perfeitamente. No entanto, em consultas específicas existem diferenças notáveis:
* **Filtros de Texto:** Se fizermos uma consulta como `SELECT * FROM livro WHERE titulo LIKE '%harry%'`, o MySQL ignora maiúsculas e minúsculas por defeito (*case-insensitive*) e encontra o livro. Já o PostgreSQL é *case-sensitive* com o `LIKE`, obrigando ao uso do operador específico `ILIKE` para ter o mesmo comportamento.
* **Obter o ID após o INSERT:** No PostgreSQL é comum adicionar a cláusula `RETURNING id` diretamente na consulta SQL de inserção. No MySQL, a consulta de inserção é padrão e dependemos do método `lastInsertId()` do PDO no PHP para recuperar o ID gerado pelo `AUTO_INCREMENT`.