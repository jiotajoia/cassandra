--keyspace

CREATE KEYSPACE loja WITH replication = {'class':'SimpleStrategy', 'replication_factor': 1};

--para usar/criar o keyspace

USE loja;

--criando a tabela

CREATE TABLE produto (
    id UUID PRIMARY KEY,
    nome text
);

CREATE TABLE funcionario (
    id UUID PRIMARY KEY,
    nome text,
    idade int
);

--insert na tabela produto

INSERT INTO produto (id, nome)
VALUES(uuid(), 'caderno');

INSERT INTO funcionario (id, nome, idade)
VALUES(uuid(), 'jiotajoia', 21);
--select

SELECT id FROM produto
WHERE nome = 'caderno' ALLOW FILTERING;

--delete

DELETE FROM produto
WHERE id = ;

--drop
DROP KEYSPACE loja;
