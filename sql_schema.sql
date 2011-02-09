SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `russiankohana_kohanaworld_dev` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `russiankohana_kohanaworld_dev` ;

-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`developers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`developers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `github_id` INT NOT NULL COMMENT 'идентификатор разработчика на github' ,
  `username` VARCHAR(128) NOT NULL COMMENT 'nickname разработчика' ,
  `date_create` INT UNSIGNED NOT NULL COMMENT 'дата создания аккаунта на github' ,
  `url` VARCHAR(256) NOT NULL COMMENT 'url страницы разработчика на Github' ,
  `realname` VARCHAR(256) NULL DEFAULT NULL COMMENT 'Полное имя разработчика' ,
  `email` VARCHAR(256) NULL DEFAULT NULL COMMENT 'email разработчика' ,
  `location` VARCHAR(256) NULL DEFAULT NULL COMMENT 'где живёт' ,
  `company` VARCHAR(256) NULL DEFAULT NULL COMMENT 'название компании' ,
  `blog_url` VARCHAR(256) NULL DEFAULT NULL COMMENT 'URL блога/сайта' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'Таблица с данными о разработчиках';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`modules`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`modules` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор модуля' ,
  `developer_id` INT UNSIGNED NOT NULL COMMENT 'автор (владелец) модуля' ,
  `name` VARCHAR(128) NOT NULL COMMENT 'название модуля' ,
  `fullname` VARCHAR(255) NOT NULL COMMENT 'полное название модуля (:username/:name)' ,
  `url` VARCHAR(255) NOT NULL COMMENT 'URL модуля на Github\'е' ,
  `homepage` VARCHAR(255) NULL DEFAULT NULL COMMENT 'домашняя страница модуля' ,
  `description` TEXT NOT NULL COMMENT 'описание модуля' ,
  `date_create` INT NOT NULL ,
  `date_update` INT NULL DEFAULT NULL ,
  `has_wiki` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'заведена wiki' ,
  `has_issues` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'имеются открытые тикеты' ,
  `has_downloads` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'имеются файлы для скачивания *' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `fullname_UNIQUE` (`fullname` ASC) ,
  INDEX `fk_module_developer` (`developer_id` ASC) ,
  CONSTRAINT `fk_module_developer`
    FOREIGN KEY (`developer_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`developers` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица для хранения информации о модулях';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`module_info`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`module_info` (
  `id` INT NOT NULL ,
  `forks` SMALLINT NOT NULL COMMENT 'количество форков' ,
  `watchers` SMALLINT NOT NULL COMMENT 'количество наблюдателей' ,
  `tags` SMALLINT NOT NULL COMMENT 'количество тэгов' ,
  `score` FLOAT(4,3) NOT NULL COMMENT 'Оценка Github' ,
  `issues_opened` SMALLINT UNSIGNED NOT NULL DEFAULT 0 ,
  `issues_closed` SMALLINT UNSIGNED NOT NULL DEFAULT 0 ,
  `module_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_module-info_module` (`module_id` ASC) ,
  CONSTRAINT `fk_module-info_module`
    FOREIGN KEY (`module_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица для хранения статистики по модулям';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`modules_dependences`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`modules_dependences` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID зависимости' ,
  `subject_id` INT UNSIGNED NOT NULL COMMENT 'зависящий модуль' ,
  `target_id` INT UNSIGNED NOT NULL COMMENT 'от кого зависит' ,
  `original_target_link` VARCHAR(256) NULL DEFAULT NULL COMMENT 'URL, прописанный в .gitmodules' ,
  `path` VARCHAR(128) NULL DEFAULT NULL COMMENT 'Относительный путь в модуле, где лежит зависимость' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_module-dependance_subject` (`subject_id` ASC) ,
  INDEX `fk_module-dependance_target` (`target_id` ASC) ,
  CONSTRAINT `fk_module-dependance_subject`
    FOREIGN KEY (`subject_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_module-dependance_target`
    FOREIGN KEY (`target_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица для хранения зависимостей между модулями';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(128) NOT NULL ,
  `developer_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_user_developer` (`developer_id` ASC) ,
  CONSTRAINT `fk_user_developer`
    FOREIGN KEY (`developer_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`developers` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Пользователи ресурса';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`developer_info`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`developer_info` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `followers` SMALLINT UNSIGNED NOT NULL DEFAULT 0 ,
  `own_repos` SMALLINT UNSIGNED NOT NULL DEFAULT 0 ,
  `developer_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_developer_info-developer` (`developer_id` ASC) ,
  CONSTRAINT `fk_developer_info-developer`
    FOREIGN KEY (`developer_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`developers` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Дополнительная информация о разработчике';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`modules_contributors`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`modules_contributors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `module_id` INT UNSIGNED NOT NULL COMMENT 'id модуля' ,
  `developer_id` INT UNSIGNED NOT NULL COMMENT 'id разработчика' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_module-contributor_module` (`module_id` ASC) ,
  INDEX `fk_module-contributor_contributor` (`developer_id` ASC) ,
  CONSTRAINT `fk_module-contributor_module`
    FOREIGN KEY (`module_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_module-contributor_contributor`
    FOREIGN KEY (`developer_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`developers` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Таблица для связи между разработчиками и модулями';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`logs`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`logs` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `executant` VARCHAR(128) NOT NULL COMMENT 'action executor (system, crawler, user, etc)' ,
  `executant_id` INT UNSIGNED NULL DEFAULT NULL COMMENT 'executor id if exists' ,
  `action` VARCHAR(128) NOT NULL COMMENT 'executor action name' ,
  `date` INT UNSIGNED NOT NULL COMMENT 'action unix timestamp' ,
  `level` VARCHAR(45) NOT NULL COMMENT 'log level (notice, warn, error, etc)' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'Application logs';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`crawler_stats`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`crawler_stats` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `log_id` INT UNSIGNED NOT NULL ,
  `new_modules` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of new modules' ,
  `updated_modules` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of updated modules' ,
  `new_developers` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of new developers' ,
  `updated_developers` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of updated developers' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_crawler-stat_log` (`log_id` ASC) ,
  CONSTRAINT `fk_crawler-stat_log`
    FOREIGN KEY (`log_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`logs` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Github crowles job statuses';



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
