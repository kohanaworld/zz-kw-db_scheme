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
  `github_id` INT NOT NULL COMMENT 'GitHub developer ID' ,
  `username` VARCHAR(128) NOT NULL COMMENT 'developer nickname' ,
  `date_create` INT UNSIGNED NOT NULL COMMENT 'GitHub account creation date' ,
  `url` VARCHAR(256) NOT NULL COMMENT 'Github developer URL' ,
  `realname` VARCHAR(256) NULL DEFAULT NULL COMMENT 'developer Fullname' ,
  `email` VARCHAR(256) NULL DEFAULT NULL COMMENT 'developer email' ,
  `location` VARCHAR(256) NULL DEFAULT NULL COMMENT 'developer location' ,
  `company` VARCHAR(256) NULL DEFAULT NULL COMMENT 'developer company' ,
  `blog_url` VARCHAR(256) NULL DEFAULT NULL COMMENT 'blog/site URL' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'Github developers table';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`modules`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`modules` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'идентификатор модуля' ,
  `developer_id` INT UNSIGNED NOT NULL COMMENT 'module developer (author)' ,
  `name` VARCHAR(128) NOT NULL COMMENT 'module name' ,
  `fullname` VARCHAR(255) NOT NULL COMMENT 'module fullname (:username/:name)' ,
  `url` VARCHAR(255) NOT NULL COMMENT 'Github module URL' ,
  `homepage` VARCHAR(255) NULL DEFAULT NULL COMMENT 'module homepage' ,
  `description` TEXT NOT NULL COMMENT 'module description' ,
  `date_create` INT NOT NULL COMMENT 'date of module creation' ,
  `has_wiki` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'wiki availability' ,
  `has_issues` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'open issues availability' ,
  `has_downloads` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'is there are files to downlod' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `fullname_UNIQUE` (`fullname` ASC) ,
  INDEX `fk_module_developer` (`developer_id` ASC) ,
  CONSTRAINT `fk_module_developer`
    FOREIGN KEY (`developer_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`developers` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Modules main info';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`module_info`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`module_info` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `module_id` INT UNSIGNED NOT NULL COMMENT 'module id' ,
  `forks` SMALLINT NOT NULL COMMENT 'number of module forks' ,
  `watchers` SMALLINT NOT NULL COMMENT 'number of module watchers' ,
  `tags` SMALLINT NOT NULL COMMENT 'number of module tags' ,
  `score` FLOAT(4,3) NOT NULL COMMENT 'Github module score' ,
  `issues_opened` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of opened issueses' ,
  `issues_closed` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of closed issueses' ,
  `date_update` INT UNSIGNED NOT NULL COMMENT 'module update date' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_module-info_module` (`module_id` ASC) ,
  CONSTRAINT `fk_module-info_module`
    FOREIGN KEY (`module_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Modules information collection';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`modules_dependences`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`modules_dependences` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID зависимости' ,
  `subject_id` INT UNSIGNED NOT NULL COMMENT 'depended module' ,
  `target_id` INT UNSIGNED NOT NULL COMMENT 'tardet module' ,
  `original_target_link` VARCHAR(256) NULL DEFAULT NULL COMMENT 'dependence URL (in .gitmodules)' ,
  `path` VARCHAR(128) NULL DEFAULT NULL COMMENT 'relative path in module where dependence is located' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_module-dependence-subject` (`subject_id` ASC) ,
  INDEX `fk_module-dependence-target` (`target_id` ASC) ,
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
COMMENT = 'modules dependences';


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
  `developer_id` INT UNSIGNED NOT NULL COMMENT 'developer ID' ,
  `followers` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of followers' ,
  `own_repos` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of own repos' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_developer-info-developer` (`developer_id` ASC) ,
  CONSTRAINT `fk_developer-info-developer`
    FOREIGN KEY (`developer_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`developers` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Дополнительная информация о разработчике';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`modules_contributors`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`modules_contributors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `module_id` INT UNSIGNED NOT NULL COMMENT 'module ID' ,
  `developer_id` INT UNSIGNED NOT NULL COMMENT 'developer ID' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_module-contributor_module` (`module_id` ASC) ,
  INDEX `fk_module-contributor_contributor` (`developer_id` ASC) ,
  CONSTRAINT `fk_module-contributor_module`
    FOREIGN KEY (`module_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_module-contributor_contributor`
    FOREIGN KEY (`developer_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`developers` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
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
  `text` VARCHAR(256) NULL COMMENT 'log message (execution result, exception triggered etc)' ,
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
  `log_id` INT UNSIGNED NOT NULL COMMENT 'log record ID' ,
  `new_modules` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of new modules' ,
  `updated_modules` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of updated modules' ,
  `new_developers` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of new developers' ,
  `updated_developers` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of updated developers' ,
  `new_tags` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of new github tags' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_crawler-stat_log` (`log_id` ASC) ,
  CONSTRAINT `fk_crawler-stat_log`
    FOREIGN KEY (`log_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`logs` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Github crowles job statuses';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`module_tags`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`module_tags` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(256) NOT NULL COMMENT 'tag name' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'Module tags in thoughts of GitHub';


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`modules_module_tags`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`modules_module_tags` (
  `module_id` INT UNSIGNED NOT NULL ,
  `module_tag_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`module_id`, `module_tag_id`) ,
  INDEX `fk_module_module-tag` (`module_tag_id` ASC) ,
  INDEX `fk_module-tag_module` (`module_id` ASC) ,
  CONSTRAINT `fk_module_module-tag`
    FOREIGN KEY (`module_tag_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`module_tags` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_module-tag_module`
    FOREIGN KEY (`module_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`crawlers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`crawlers` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `type` VARCHAR(100) NOT NULL ,
  `page` SMALLINT(5) UNSIGNED NOT NULL ,
  `updated` INT(10) UNSIGNED NOT NULL ,
  `stopped` TINYINT(1) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `unique_type` (`type` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `russiankohana_kohanaworld_dev`.`module_info_history`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `russiankohana_kohanaworld_dev`.`module_info_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `date_create` INT UNSIGNED NOT NULL ,
  `module_id` INT UNSIGNED NOT NULL COMMENT 'module id' ,
  `forks` SMALLINT NOT NULL COMMENT 'number of module forks' ,
  `watchers` SMALLINT NOT NULL COMMENT 'number of module watchers' ,
  `tags` SMALLINT NOT NULL COMMENT 'number of module tags' ,
  `score` FLOAT(4,3) NOT NULL COMMENT 'Github module score' ,
  `issues_opened` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of opened issueses' ,
  `issues_closed` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'number of closed issueses' ,
  `date_update` INT UNSIGNED NOT NULL COMMENT 'module update date' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_module-info-history_module` (`module_id` ASC) ,
  CONSTRAINT `fk_module-info-history_module`
    FOREIGN KEY (`module_id` )
    REFERENCES `russiankohana_kohanaworld_dev`.`modules` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Modules information history';



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
