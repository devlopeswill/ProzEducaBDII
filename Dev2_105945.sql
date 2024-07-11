/* Desenvolvimento 2 #105945
INSTRUÇÕES DO PROJETO
Crie um banco de dados, adicione tabelas e determine quais são os atributos de cada uma. Em seguida, execute um trigger que se relacione com algum comando, como insert, select, delete ou update.
Trabalhe esse código em seu IDE, suba ele para sua conta no GitHub e compartilhe o link desse projeto no campo ao lado para que outros desenvolvedores possam analisá-lo.
*/

CREATE DATABASE MeuBancoDeDados;

USE MeuBancoDeDados;

CREATE TABLE Clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    cliente_id INT,
    valor DECIMAL(10, 2)
);

DELIMITER //
CREATE TRIGGER MeuTrigger
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    -- Seu código aqui (por exemplo, enviar um e-mail quando um novo pedido for inserido)
END;
//
DELIMITER ;

-----------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE funcionario (
    autoId SERIAL   NOT NULL PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    departamento    INT  NOT NULL,
    salario         DECIMAL  NOT NULL,
    comissao        DECIMAL
);

CREATE TABLE sal_excecao (
    autoId SERIAL NOT NULL PRIMARY KEY,
    funcionario     INT,
    salario_ant     DECIMAL,
    salario_novo    DECIMAL,
	FOREIGN KEY(funcionario)
    REFERENCES funcionario(autoId)
   ON DELETE CASCADE
);

CREATE INDEX idx_funcionario
ON sal_excecao (funcionario);


/*
Este modelo de trigger é utilizado em PL/SQL(Oracle) e tem muita semelhança com o modelo que foi apresentado na JoyClass
Porem este modelo não está funcionando no banco PostgreSQL(https://sqliteonline.com/)
A forma como as trigger são construidas neste banco é diferente(Utiliza-se o conceito de FUNCTION - Aqui o exemplo: https://imasters.com.br/data/triggers-no-postgresql

Sendo que a construção de trigger no SQLite é mais proximas deste modelo, porem tem que fazer alguns ajustes(Vou fazer em outro momento): 
https://www.sqlite.org/lang_createtrigger.html
https://www.sqlitetutorial.net/sqlite-trigger/
*/
CREATE OR REPLACE TRIGGER atualiza_salario
    BEFORE INSERT OR UPDATE ON funcionario
    FOR EACH ROW
BEGIN
    IF (:NEW.departamento = 10 and INSERTING) THEN
        :NEW.comissao := :NEW.salario * .4;
    END IF;

    IF (UPDATING and (:NEW.salario - :OLD.salario) > :OLD.salario * .5) THEN
       INSERT INTO sal_excecao VALUES (:NEW.funcionario, :OLD.salario_ant, :NEW.salario_novo);
    END IF;
END
