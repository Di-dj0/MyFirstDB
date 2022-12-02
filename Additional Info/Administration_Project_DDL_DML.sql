BEGIN;

DROP TABLE IF EXISTS EXPERTISE CASCADE;
DROP TABLE IF EXISTS CLASSES CASCADE;
DROP TABLE IF EXISTS PROJECTS CASCADE;
DROP TABLE IF EXISTS TASK_STATUS CASCADE;
DROP TABLE IF EXISTS TASKS CASCADE;

CREATE TABLE IF NOT EXISTS PROJECTS
(
    proj_id char(4) NOT NULL,
    proj_name character varying(40) NOT NULL,
    proj_desc character varying(80),
    proj_start_date date NOT NULL,
    proj_end_date date NOT NULL,
    CONSTRAINT pk_proj_id PRIMARY KEY (proj_id)
);
COMMENT ON TABLE PROJECTS IS 'Table responsable for holding projects information, doing and to-do.';

CREATE TABLE IF NOT EXISTS CLASSES
(
    class_id integer NOT NULL,
    class_name character varying(40) NOT NULL,
    class_desc character varying(80),
    header_class integer[],
    CONSTRAINT pk_class_id PRIMARY KEY (class_id)
);
COMMENT ON TABLE CLASSES IS 'Table responsable for grouping tasks in different steps of the project.';

CREATE TABLE IF NOT EXISTS EXPERTISE
(
    exp_id char(4) NOT NULL,
    exp_name character varying(40) NOT NULL,
    exp_desc character varying(80),
    CONSTRAINT pk_exp_id PRIMARY KEY (exp_id)
);
COMMENT ON TABLE EXPERTISE IS 'Table responsable for indicating witch expertise is working on the witch task.';

CREATE TABLE IF NOT EXISTS TASK_STATUS
(
	status_id integer NOT NULL,
	status_desc character varying(40) NOT NULL,
	CONSTRAINT pk_stat_id PRIMARY KEY (status_id)
);
COMMENT ON TABLE TASK_STATUS IS 'Table responsable for indicating what task status exists and what it represents.';

CREATE TABLE IF NOT EXISTS TASKS
(
	task_id integer NOT NULL,
	task_name character varying(80) NOT NULL,
    proj_id char(4) NOT NULL,
    class_id integer NOT NULL,
    exp_id char(4),
    duration integer NOT NULL DEFAULT 1,
    predecessor_id integer[],    
    status integer NOT NULL DEFAULT 1,
    CONSTRAINT pk_task_id PRIMARY KEY (task_id, proj_id),
    CONSTRAINT uk_task_id UNIQUE (task_id, proj_id)
);
COMMENT ON TABLE TASKS IS 'Bigger table, used for storing any tasks necessary for any projects, unsing relations like "Witch project, witch team, with witch expertise, and status".';


ALTER TABLE IF EXISTS PROJECTS
	ADD CONSTRAINT ck_proj_date CHECK (proj_end_date > proj_start_date);
	
ALTER TABLE IF EXISTS TASKS
	ADD CONSTRAINT ck_task_date CHECK (duration > 0);
	
ALTER TABLE IF EXISTS TASKS
	ADD CONSTRAINT ck_task_stat CHECK (status >= 1 AND status <= 5);

ALTER TABLE IF EXISTS TASKS
    ADD CONSTRAINT fk_task_proj_id FOREIGN KEY (proj_id)
    REFERENCES PROJECTS (proj_id);


ALTER TABLE IF EXISTS TASKS
    ADD CONSTRAINT fk_task_class_id FOREIGN KEY (class_id)
    REFERENCES CLASSES (class_id);


ALTER TABLE IF EXISTS TASKS
    ADD CONSTRAINT fk_task_exp_id FOREIGN KEY (exp_id)
    REFERENCES EXPERTISE (exp_id);

ALTER TABLE IF EXISTS TASKS
    ADD CONSTRAINT fk_task_stat_id FOREIGN KEY (status)
    REFERENCES TASK_STATUS (status_id);

ALTER TABLE IF EXISTS CLASSES
    ADD CONSTRAINT fk_header_class_id FOREIGN KEY (class_id)
    REFERENCES CLASSES (class_id);

END;

-- INSERTS (AND WHATS THE STRUCTURE OF THEM)

-- 	PROJECTS ('proj_id', 'proj_name', 'proj_desc', 'proj_start_date', 'proj_end_date');
INSERT INTO PROJECTS VALUES('PMIR', 'Template de Projeto PMI-RIO', '', '2009-10-11', '2009-11-01');

-- CLASSES (class_id, 'class_name', 'class_desc', '{header_class}');
INSERT INTO CLASSES VALUES(1, 'Template do Projeto' );
INSERT INTO CLASSES VALUES(2, 'Iniciação', 'Início do projeto');
INSERT INTO CLASSES VALUES(5, 'Planejamento', 'Planejamento para o projeto', '{2}');
INSERT INTO CLASSES VALUES(26, 'Execução', 'Execução do planejamento', '{5}');
INSERT INTO CLASSES VALUES(35, 'Controle', 'Controle do planejamento', '{5}');
INSERT INTO CLASSES VALUES(46, 'Encerramento', 'Finalização do projeto', '{26,35}');

-- EXPERTISE ('exp_id', 'exp_name', 'exp_desc');
INSERT INTO EXPERTISE VALUES('INTE', 'Integração');
INSERT INTO EXPERTISE VALUES('COMU', 'Comunicações');
INSERT INTO EXPERTISE VALUES('ESCO', 'Escopo');
INSERT INTO EXPERTISE VALUES('TEMP', 'Tempo');
INSERT INTO EXPERTISE VALUES('CUST', 'Custos');
INSERT INTO EXPERTISE VALUES('RISC', 'Riscos');
INSERT INTO EXPERTISE VALUES('RH', 'Recursos Humanos');
INSERT INTO EXPERTISE VALUES('QUAL', 'Qualidade');
INSERT INTO EXPERTISE VALUES('AQUI', 'Aquisições');

-- TASK_STATUS (status_id, 'status_desc');
INSERT INTO TASK_STATUS VALUES(1, 'Iniciada');
INSERT INTO TASK_STATUS VALUES(2, 'Não iniciada');
INSERT INTO TASK_STATUS VALUES(3, 'Interrompida');
INSERT INTO TASK_STATUS VALUES(4, 'Cancelada');
INSERT INTO TASK_STATUS VALUES(5, 'Concluída');



-- TASKS (task_id, 'task_name', 'proj_id', class_id, 'exp_id', duration, '{predecessor_id}', status);
INSERT INTO TASKS VALUES(3, 'Desenvolver o termo de abertura do projeto', 'PMIR', 2, 'INTE', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Identificar as partes interessadas', 'PMIR', 2, 'COMU', DEFAULT, '{3}', DEFAULT);

INSERT INTO TASKS VALUES(6, 'Desenvolver o plano de gerenciamento do projeto', 'PMIR', 5, 'INTE', 10, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Coletar os requisitos', 'PMIR', 5, 'ESCO', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Definir o escopo', 'PMIR', 5, 'ESCO', DEFAULT, '{7}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Criar a EAP', 'PMIR', 5, 'ESCO', DEFAULT, '{8}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Definir as atividades', 'PMIR', 5, 'TEMP', DEFAULT, '{9}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Sequenciar as atividades', 'PMIR', 5, 'TEMP', DEFAULT, '{10}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Estimar os recursos das atividades', 'PMIR', 5, 'TEMP', DEFAULT, '{11}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Estimar as durações das atividades', 'PMIR', 5, 'TEMP', DEFAULT, '{12}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Desenvolver o cronograma', 'PMIR', 5, 'TEMP', DEFAULT, '{13,21}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Estimar os custos', 'PMIR', 5, 'CUST', DEFAULT, '{13}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Determinar o orçamento', 'PMIR', 5, 'CUST', DEFAULT, '{15,14,21}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Planejar o gerenciamento dos riscos', 'PMIR', 5, 'RISC', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Identificar os riscos', 'PMIR', 5, 'RISC', DEFAULT, '{17}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Realizar a análise qualitativa dos riscos', 'PMIR', 5, 'RISC', DEFAULT, '{18}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Realizar a análise quantitativa dos riscos', 'PMIR', 5, 'RISC', DEFAULT, '{19}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Planejar as respostas aos riscos', 'PMIR', 5, 'RISC', DEFAULT, '{20}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Desenvolver o plano dos recursos humanos', 'PMIR', 5, 'RH', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Planejar a qualidade', 'PMIR', 5, 'QUAL', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Planejar as comunicações', 'PMIR', 5, 'COMU', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Planejar as aquisições', 'PMIR', 5, 'AQUI', DEFAULT, '{21,14,16}', DEFAULT);

INSERT INTO TASKS VALUES(27, 'Orientar e gerenciar a execução do projeto', 'PMIR', 26, 'INTE', 5, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Realizar a garantia de qualidade', 'PMIR', 26, 'QUAL', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Mobilizar a equipe do projeto', 'PMIR', 26, 'RH', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Desenvolver a equipe do projeto', 'PMIR', 26, 'RH', DEFAULT, '{29}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Gerenciar a equipe do projeto', 'PMIR', 26, 'RH', DEFAULT, '{30}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Conduzir as aquisições', 'PMIR', 26, 'AQUI', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Distribuir as informações', 'PMIR', 26, 'COMU', DEFAULT, '{32,31}', DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Gerenciar as expectativas das partes interessadas', 'PMIR', 26, 'COMU', DEFAULT, '{33}', DEFAULT);

INSERT INTO TASKS VALUES(36, 'Realizar o controle integrado de mudanças', 'PMIR', 35, 'INTE', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Monitorar e controlar o trabalho no projeto', 'PMIR', 35, 'INTE', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Verificar o escopo', 'PMIR', 35, 'ESCO', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Controlar o escopo', 'PMIR', 35, 'ESCO', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Controlar o cronograma', 'PMIR', 35, 'TEMP', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Controlar os custos', 'PMIR', 35, 'CUST', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Realizar o controle da qualidade', 'PMIR', 35, 'QUAL', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Relatar o desempenho', 'PMIR', 35, 'COMU', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Monitorar e controlar os riscos', 'PMIR', 35, 'RISC', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Administrar as aquisições', 'PMIR', 35, 'AQUI', DEFAULT, NULL, DEFAULT);

INSERT INTO TASKS VALUES(47, 'Encerrar o projeto ou fase', 'PMIR', 46, 'INTE', DEFAULT, NULL, DEFAULT);
INSERT INTO TASKS VALUES((SELECT MAX(task_id)+1 FROM tasks), 'Encerrar as aquisições', 'PMIR', 46, 'AQUI', DEFAULT, NULL, DEFAULT);


-- SEARCH EXAMPLES

-- SELECT THE TASKS THAT WILL TAKE LONGER THAN THE DEFAULT 1 DAY
-- SELECT * FROM TASKS WHERE duration > 1;

-- SELECT ALL THE TASKS THAT THE 'ESCOPO' TEAM HAS IN ITS BACKLOG
-- SELECT * FROM TASKS WHERE exp_id = 'ESCO' ORDER BY 1;

-- SUM ALL DAYS THAT THE 'Tempo' TEAM WILL WORK ON TOTAL
-- SELECT SUM(duration) AS total_days_working FROM TASKS WHERE exp_id = 'TEMP';
