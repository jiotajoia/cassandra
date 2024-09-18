--keyspace

CREATE KEYSPACE meu_novo_keyspace WITH replication {'class':'SimpleStrategy', 'replication_factor': 1};

--para usar/criar o keyspace

USE meu_novo_keyspace;

--criando a tabela

CREATE TABLE produto {
    id UUID PRIMARY KEY,
    nome text
};

--insert na tabela produto

INSERT INTO produto 
VALUES(uuid(), 'caderno');

--select

SELECT id FROM produto
WHERE nome = 'caderno';

--delete

DELETE FROM produto
WHERE nome = 'caderno';