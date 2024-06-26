-- Criando o Banco de Dados
CREATE DATABASE hospedar_db;
USE hospedar_db;

-- Criação das Tabelas
CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf VARCHAR(2) NOT NULL,
    classificacao INT NOT NULL
);

CREATE TABLE Quarto (
    quarto_id INT PRIMARY KEY,
    hotel_id INT NOT NULL,
    numero INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    preco_diaria DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE Hospedagem (
    hospedagem_id INT PRIMARY KEY,
    cliente_id INT NOT NULL,
    quarto_id INT NOT NULL,
    dt_checkin DATE NOT NULL,
    dt_checkout DATE NOT NULL,
    valor_total_hosp FLOAT NOT NULL,
    status_hosp VARCHAR(20) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (quarto_id) REFERENCES Quarto(quarto_id)
);

-- Inserindo dados na tabela Hotel
INSERT INTO Hotel (hotel_id, nome, cidade, uf, classificacao)
VALUES
(1, 'Hotel A', 'São Paulo', 'SP', 4),
(2, 'Hotel B', 'Rio de Janeiro', 'RJ', 5);

-- Inserindo dados na tabela Quarto
INSERT INTO Quarto (quarto_id, hotel_id, numero, tipo, preco_diaria)
VALUES
(1, 1, 101, 'Standard', 200.00),
(2, 2, 102, 'Standard', 300.00),
(3, 1, 103, 'Deluxe', 400.00),
(4, 2, 104, 'Deluxe', 200.00),
(5, 1, 105, 'Standard', 300.00),
(6, 2, 201, 'Standard', 250.00),
(7, 1, 202, 'Standard Premium', 350.00),
(8, 2, 203, 'Standard Premium', 450.00),
(9, 1, 204, 'Deluxe Premium', 250.00),
(10, 2, 205, 'Deluxe Premium', 350.00);

-- Inserindo dados na tabela Cliente
INSERT INTO Cliente (cliente_id, nome, email, telefone, cpf)
VALUES
(1, 'Pedro', 'pedro@example.com', '11999999999', '12345678901'),
(2, 'Vinicius', 'vinicius@example.com', '21999999999', '23456789012'),
(3, 'Alexandre', 'alexandre@example.com', '31999999999', '34567890123');

-- Inserindo dados na tabela Hospedagem
INSERT INTO Hospedagem (hospedagem_id, cliente_id, quarto_id, dt_checkin, dt_checkout, valor_total_hosp, status_hosp)
VALUES
-- Hospedagens com status "reserva"
(1, 1, 1, '2024-06-01', '2024-06-05', 800.00, 'reserva'),
(2, 1, 2, '2024-06-06', '2024-06-10', 1200.00, 'reserva'),
(3, 2, 3, '2024-06-11', '2024-06-15', 1600.00, 'reserva'),
(4, 2, 4, '2024-06-16', '2024-06-20', 800.00, 'reserva'),
(5, 3, 5, '2024-06-21', '2024-06-25', 1200.00, 'reserva'),
-- Hospedagens com status "finalizada"
(6, 1, 6, '2024-01-01', '2024-01-05', 1000.00, 'finalizada'),
(7, 1, 7, '2024-01-06', '2024-01-10', 1400.00, 'finalizada'),
(8, 2, 8, '2024-01-11', '2024-01-15', 1800.00, 'finalizada'),
(9, 2, 9, '2024-01-16', '2024-01-20', 1000.00, 'finalizada'),
(10, 3, 10, '2024-01-21', '2024-01-25', 1400.00, 'finalizada'),
-- Hospedagens com status "hospedado"
(11, 1, 1, '2024-06-15', '2024-06-20', 1000.00, 'hospedado'),
(12, 2, 2, '2024-06-21', '2024-06-25', 1500.00, 'hospedado'),
(13, 3, 3, '2024-06-26', '2024-06-30', 2000.00, 'hospedado'),
(14, 1, 4, '2024-07-01', '2024-07-05', 1000.00, 'hospedado'),
(15, 2, 5, '2024-07-06', '2024-07-10', 1500.00, 'hospedado'),
-- Hospedagens com status "cancelada"
(16, 3, 6, '2024-02-01', '2024-02-05', 1000.00, 'cancelada'),
(17, 2, 7, '2024-02-06', '2024-02-10', 1400.00, 'cancelada'),
(18, 3, 8, '2024-02-11', '2024-02-15', 1800.00, 'cancelada'),
(19, 1, 9, '2024-02-16', '2024-02-20', 1000.00, 'cancelada'),
(20, 2, 10, '2024-02-21', '2024-02-25', 1400.00, 'cancelada');

-- Listar todos os hotéis e seus respectivos quartos
SELECT h.nome AS hotel_nome, h.cidade, q.tipo, q.preco_diaria
FROM Hotel h
JOIN Quarto q ON h.hotel_id = q.hotel_id;

-- Listar todos os clientes com hospedagens finalizadas
SELECT c.nome AS cliente_nome, q.tipo AS quarto_tipo, h.nome AS hotel_nome
FROM Hospedagem hs
JOIN Cliente c ON hs.cliente_id = c.cliente_id
JOIN Quarto q ON hs.quarto_id = q.quarto_id
JOIN Hotel h ON q.hotel_id = h.hotel_id
WHERE hs.status_hosp = 'finalizada';

-- Mostrar histórico de hospedagens de um cliente específico
SELECT hs.*
FROM Hospedagem hs
WHERE hs.cliente_id = 1
ORDER BY hs.dt_checkin;

-- Apresentar o cliente com maior número de hospedagens
SELECT c.nome AS cliente_nome, COUNT(*) AS total_hospedagens
FROM Hospedagem hs
JOIN Cliente c ON hs.cliente_id = c.cliente_id
GROUP BY c.cliente_id
ORDER BY total_hospedagens DESC
LIMIT 1;

-- Clientes com hospedagens canceladas
SELECT c.nome AS cliente_nome, q.numero AS quarto_numero, h.nome AS hotel_nome
FROM Hospedagem hs
JOIN Cliente c ON hs.cliente_id = c.cliente_id
JOIN Quarto q ON hs.quarto_id = q.quarto_id
JOIN Hotel h ON q.hotel_id = h.hotel_id
WHERE hs.status_hosp = 'cancelada';

-- Receita de todos os hotéis
SELECT h.nome AS hotel_nome, SUM(hs.valor_total_hosp) AS total_receita
FROM Hospedagem hs
JOIN Quarto q ON hs.quarto_id = q.quarto_id
JOIN Hotel h ON q.hotel_id = h.hotel_id
WHERE hs.status_hosp = 'finalizada'
GROUP BY h.hotel_id
ORDER BY total_receita DESC;

-- Clientes que já fizeram uma reserva em um hotel específico
SELECT DISTINCT c.nome AS cliente_nome
FROM Hospedagem hs
JOIN Cliente c ON hs.cliente_id = c.cliente_id
JOIN Quarto q ON hs.quarto_id = q.quarto_id
WHERE q.hotel_id = 2;

-- Quanto cada cliente gastou em hospedagens finalizadas
SELECT c.nome AS cliente_nome, SUM(hs.valor_total_hosp) AS total_gasto
FROM Hospedagem hs
JOIN Cliente c ON hs.cliente_id = c.cliente_id
WHERE hs.status_hosp = 'finalizada'
GROUP BY c.cliente_id
ORDER BY total_gasto DESC;

--  Quartos que ainda não receberam hóspedes
SELECT q.quarto_id, q.numero, q.tipo, q.preco_diaria
FROM Quarto q
LEFT JOIN Hospedagem hs ON q.quarto_id = hs.quarto_id
WHERE hs.hospedagem_id IS NULL;

-- Média de preços de diárias por tipo de quarto
SELECT q.tipo, AVG(q.preco_diaria) AS media_preco_diaria
FROM Quarto q
GROUP BY q.tipo;

-- Adicionar a coluna checkin_realizado e atualizar valores
ALTER TABLE Hospedagem ADD COLUMN checkin_realizado BOOLEAN;

UPDATE Hospedagem
SET checkin_realizado = CASE
    WHEN status_hosp IN ('finalizada', 'hospedado') THEN TRUE
    ELSE FALSE
END;

-- Renomear a coluna classificacao para ratting
ALTER TABLE Hotel CHANGE COLUMN classificacao ratting INT;

-- Procedure RegistrarCheckIn
DELIMITER //
CREATE PROCEDURE RegistrarCheckIn(IN p_hospedagem_id INT, IN p_data_checkin DATE)
BEGIN
    UPDATE Hospedagem
    SET dt_checkin = p_data_checkin, status_hosp = 'hospedado'
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- Procedure CalcularTotalHospedagem
DELIMITER //
CREATE PROCEDURE CalcularTotalHospedagem(IN p_hospedagem_id INT)
BEGIN
    DECLARE v_preco_diaria DECIMAL(10, 2);
    DECLARE v_dt_checkin DATE;
    DECLARE v_dt_checkout DATE;
    DECLARE v_total FLOAT;
    
    SELECT q.preco_diaria, hs.dt_checkin, hs.dt_checkout
    INTO v_preco_diaria, v_dt_checkin, v_dt_checkout
    FROM Hospedagem hs
    JOIN Quarto q ON hs.quarto_id = q.quarto_id
    WHERE hs.hospedagem_id = p_hospedagem_id;
    
    SET v_total = DATEDIFF(v_dt_checkout, v_dt_checkin) * v_preco_diaria;
    
    UPDATE Hospedagem
    SET valor_total_hosp = v_total
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- Procedure RegistrarCheckout
DELIMITER //
CREATE PROCEDURE RegistrarCheckout(IN p_hospedagem_id INT, IN p_data_checkout DATE)
BEGIN
    UPDATE Hospedagem
    SET dt_checkout = p_data_checkout, status_hosp = 'finalizada'
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- Desativar o modo de atualização segura
SET SQL_SAFE_UPDATES = 0;

-- Criação das Funções
-- Function TotalHospedagensHotel
UPDATE Hospedagem
SET checkin_realizado = CASE
    WHEN status_hosp IN ('finalizada', 'hospedado') THEN TRUE
    ELSE FALSE
END;

DELIMITER //
CREATE FUNCTION TotalHospedagensHotel(p_hotel_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    
    SELECT COUNT(*)
    INTO v_total
    FROM Hospedagem hs
    JOIN Quarto q ON hs.quarto_id = q.quarto_id
    WHERE q.hotel_id = p_hotel_id;
    
    RETURN v_total;
END //
DELIMITER ;

-- Function ValorMedioDiariasHotel
DELIMITER //
CREATE FUNCTION ValorMedioDiariasHotel(p_hotel_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_media DECIMAL(10, 2);
    
    SELECT AVG(q.preco_diaria)
    INTO v_media
    FROM Quarto q
    WHERE q.hotel_id = p_hotel_id;
    
    RETURN v_media;
END //
DELIMITER ;

-- Function VerificarDisponibilidadeQuarto
DELIMITER //
CREATE FUNCTION VerificarDisponibilidadeQuarto(p_quarto_id INT, p_data DATE)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_disponivel BOOLEAN;
    
    SET v_disponivel = NOT EXISTS (
        SELECT 1
        FROM Hospedagem hs
        WHERE hs.quarto_id = p_quarto_id
          AND p_data BETWEEN hs.dt_checkin AND hs.dt_checkout
    );
    
    RETURN v_disponivel;
END //
DELIMITER ;

-- Criação das Triggers
-- Trigger AntesDeInserirHospedagem
DELIMITER //
CREATE TRIGGER AntesDeInserirHospedagem
BEFORE INSERT ON Hospedagem
FOR EACH ROW
BEGIN
    DECLARE v_disponivel BOOLEAN;
    
    SET v_disponivel = NOT EXISTS (
        SELECT 1
        FROM Hospedagem hs
        WHERE hs.quarto_id = NEW.quarto_id
          AND NEW.dt_checkin BETWEEN hs.dt_checkin AND hs.dt_checkout
    );
    
    IF v_disponivel = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quarto não está disponível na data de check-in.';
    END IF;
END //
DELIMITER ;

-- Trigger AposDeletarCliente
CREATE TABLE LogExclusoes (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    nome VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(15),
    cpf VARCHAR(11),
    data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER AposDeletarCliente
AFTER DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO LogExclusoes (cliente_id, nome, email, telefone, cpf)
    VALUES (OLD.cliente_id, OLD.nome, OLD.email, OLD.telefone, OLD.cpf);
END //
DELIMITER ;
