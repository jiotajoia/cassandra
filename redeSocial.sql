--keyspace

CREATE KEYSPACE rede_social WITH replication = {'class':'SimpleStrategy', 'replication_factor': 1};

--para usar/criar o keyspace

USE rede_social;

--criando a tabela

CREATE TABLE Users (
    id_user UUID PRIMARY KEY,
    name text,
    email text,
    username text
);

CREATE TABLE Posts (
    id_post UUID,
    id_user UUID,
    date TIMESTAMP,
    title text,
    content text,
    PRIMARY KEY (id_user, id_post, date)
)WITH CLUSTERING ORDER BY (id_post ASC, date DESC);

CREATE TABLE Comments (
	id_comment UUID,
    id_post UUID,
    id_user UUID,
    date TIMESTAMP,
    title text,
    content text,
    PRIMARY KEY (id_post, date, id_comment)
) WITH CLUSTERING ORDER BY (date DESC, id_comment ASC);

--tabelas para otimizar consultas
CREATE TABLE posts_comments (
    id_post UUID,
    id_comment UUID,
    date TIMESTAMP,
    content text,
    PRIMARY KEY (id_post, id_comment, date)
)WITH CLUSTERING ORDER BY (id_comment ASC, date DESC);

CREATE TABLE user_comments (
    id_user UUID,
    id_comment UUID,
    date TIMESTAMP,
    id_post UUID,
    content text,
    PRIMARY KEY (id_user, id_comment, date)
)WITH CLUSTERING ORDER BY (id_comment ASC, date DESC);


--inserts

	--users
INSERT INTO Users (id_user, name, email, username) VALUES (uuid(), 'Italac Silva', 'italac.silva@example.com', 'italac');

INSERT INTO Users (id_user, name, email, username) VALUES (uuid(), 'Maxine Oliveira', 'maxine.oliveira@example.com', 'maxine');

INSERT INTO Users (id_user, name, email, username) VALUES (uuid(), 'Jio Tajoia', 'jio.tajoia@example.com', 'jiotajoia');

	--posts
INSERT INTO Posts (id_post, id_user, date, title, content) VALUES (uuid(), (SELECT id_user FROM Users WHERE username = 'italac'), toTimestamp(now()), 'Primeiro Post', 'Este é o primeiro post do Italac.');

INSERT INTO Posts (id_post, id_user, date, title, content) VALUES (uuid(), (SELECT id_user FROM Users WHERE username = 'maxine'), toTimestamp(now()), 'Post sobre Cassandra', 'Este é um post de Maxine sobre Cassandra.');

INSERT INTO Posts (id_post, id_user, date, title, content) VALUES (uuid(), (SELECT id_user FROM Users WHERE username = 'jiotajoia'), toTimestamp(now()), 'Vida de Jiotajoia', 'A Jio compartilhou sua experiência de vida.');

	--comments
INSERT INTO Comments (id_comment, id_post, id_user, date, title, content) VALUES (uuid(), (SELECT id_post FROM Posts WHERE title = 'Primeiro Post'), (SELECT id_user FROM Users WHERE username = 'maxine'), toTimestamp(now()), 'Comentário 1', 'Comentário de Maxine no post do Italac.');

INSERT INTO Comments (id_comment, id_post, id_user, date, title, content) VALUES (uuid(), c8d0ad15-237d-45c6-b949-fea7b58afc9f, 86f1b235-efa9-4e85-973a-cfd92cde0477, toTimestamp(now()), 'Comentário 1', 'Comentário de Maxine no post do Italac.');

 c8d0ad15-237d-45c6-b949-fea7b58afc9f
 86f1b235-efa9-4e85-973a-cfd92cde0477


INSERT INTO Comments (id_comment, id_post, id_user, date, title, content) VALUES (uuid(), (SELECT id_post FROM Posts WHERE title = 'Vida de Jiotajoia'), (SELECT id_user FROM Users WHERE username = 'italac'), toTimestamp(now()), 'Comentário 2', 'Comentário do Italac no post da Jio.');


INSERT INTO Comments (id_comment, id_post, id_user, date, title, content) VALUES (uuid(), 5f4dab44-2f22-40c8-a6cf-7e4c3e9ebf10,  9f3ef00d-6d4b-404f-828e-e8e672217e6b, toTimestamp(now()), 'Comentário 2', 'Comentário do Italac no post da Jio.');


 5f4dab44-2f22-40c8-a6cf-7e4c3e9ebf10
 9f3ef00d-6d4b-404f-828e-e8e672217e6b

	--posts_comments
INSERT INTO posts_comments (id_post, id_comment, date, content) VALUES ((SELECT id_post FROM Posts WHERE title = 'Primeiro Post'), (SELECT id_comment FROM Comments WHERE title = 'Comentário 1'), toTimestamp(now()), 'Comentário da Maxine no post do Italac.');

INSERT INTO posts_comments (id_post, id_comment, date, content) VALUES (c8d0ad15-237d-45c6-b949-fea7b58afc9f, 91505846-d604-4466-864a-c520c3a485f1, toTimestamp(now()), 'Comentário da Maxine no post do Italac.');

c8d0ad15-237d-45c6-b949-fea7b58afc9f
91505846-d604-4466-864a-c520c3a485f1

INSERT INTO posts_comments (id_post, id_comment, date, content) VALUES ((SELECT id_post FROM Posts WHERE title = 'Vida de Jiotajoia'), (SELECT id_comment FROM Comments WHERE title = 'Comentário 2'), toTimestamp(now()), 'Comentário do Italac no post do Jio.');

INSERT INTO posts_comments (id_post, id_comment, date, content) VALUES (5f4dab44-2f22-40c8-a6cf-7e4c3e9ebf10, f0306796-d52d-4447-973a-45847854450f toTimestamp(now()), 'Comentário do Italac no post do Jio.');

5f4dab44-2f22-40c8-a6cf-7e4c3e9ebf10
f0306796-d52d-4447-973a-45847854450f

	--user_comments
INSERT INTO user_comments (id_user, id_comment, date, id_post, content) VALUES ((SELECT id_user FROM Users WHERE username = 'maxine'), (SELECT id_comment FROM Comments WHERE title = 'Comentário 1'), toTimestamp(now()), (SELECT id_post FROM Posts WHERE title = 'Primeiro Post'), 'Comentário de Maxine no post do Italac.');

INSERT INTO user_comments (id_user, id_comment, date, id_post, content) VALUES (86f1b235-efa9-4e85-973a-cfd92cde0477, 91505846-d604-4466-864a-c520c3a485f1, toTimestamp(now()), c8d0ad15-237d-45c6-b949-fea7b58afc9f, 'Comentário de Maxine no post do Italac.');

86f1b235-efa9-4e85-973a-cfd92cde0477
91505846-d604-4466-864a-c520c3a485f1
c8d0ad15-237d-45c6-b949-fea7b58afc9f


INSERT INTO user_comments (id_user, id_comment, date, id_post, content) VALUES ((SELECT id_user FROM Users WHERE username = 'italac'), (SELECT id_comment FROM Comments WHERE title = 'Comentário 2'), toTimestamp(now()), (SELECT id_post FROM Posts WHERE title = 'Vida de Jiotajoia'), 'Comentário do Italac no post da Jio.');

INSERT INTO user_comments (id_user, id_comment, date, id_post, content) VALUES (9f3ef00d-6d4b-404f-828e-e8e672217e6b, f0306796-d52d-4447-973a-45847854450f, toTimestamp(now()), 5f4dab44-2f22-40c8-a6cf-7e4c3e9ebf10, 'Comentário do Italac no post da Jio.');

9f3ef00d-6d4b-404f-828e-e8e672217e6b
f0306796-d52d-4447-973a-45847854450f
5f4dab44-2f22-40c8-a6cf-7e4c3e9ebf10

--consultas

SELECT * FROM Posts WHERE id_user = c20ad95f-c392-4435-aa56-4fcaf69d5343 allow filtering; --busca o usuario 'jiotajoia' 

SELECT * FROM posts_comments WHERE id_post = 6fd8fa6a-445c-473e-bf61-f94048c27cac allow filtering; -- busca o 'post sobre cassandra'

SELECT * FROM user_comments WHERE id_user = 9f3ef00d-6d4b-404f-828e-e8e672217e6b allow filtering; --busca os comentários feitos por 'italac'

SELECT * FROM Comments WHERE id_post = 5f4dab44-2f22-40c8-a6cf-7e4c3e9ebf10 ORDER BY date DESC allow filtering; --busca e ordenar os comentários no post 'Vida de Jiotajoia'



