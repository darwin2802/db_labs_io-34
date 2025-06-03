-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema my_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `my_db` ;

CREATE SCHEMA IF NOT EXISTS `my_db` DEFAULT CHARACTER SET utf8 ;
USE `my_db` ;

-- -----------------------------------------------------
-- Table `my_db`.`Content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Content` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Content` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uploader_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `category` VARCHAR(50) NULL DEFAULT NULL,
  `url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`Queue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Queue` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Queue` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `reviewer_id` INT UNSIGNED NULL DEFAULT NULL,
  `status` VARCHAR(50) NULL DEFAULT NULL,
  `Content_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Content_id`),
  INDEX `fk_Queue_Content_idx` (`Content_id` ASC) VISIBLE,
  CONSTRAINT `fk_Queue_Content`
    FOREIGN KEY (`Content_id`)
    REFERENCES `my_db`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`Label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Label` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Label` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`ContentLabel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`ContentLabel` ;

CREATE TABLE IF NOT EXISTS `my_db`.`ContentLabel` (
  `Content_id` INT UNSIGNED NOT NULL,
  `Label_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Content_id`, `Label_id`),
  INDEX `fk_ContentLabel_Content1_idx` (`Content_id` ASC) VISIBLE,
  INDEX `fk_ContentLabel_Label1_idx` (`Label_id` ASC) VISIBLE,
  CONSTRAINT `fk_ContentLabel_Content1`
    FOREIGN KEY (`Content_id`)
    REFERENCES `my_db`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ContentLabel_Label1`
    FOREIGN KEY (`Label_id`)
    REFERENCES `my_db`.`Label` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`Subscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Subscription` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Subscription` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` INT UNSIGNED NOT NULL,
  `expires` DATE NULL DEFAULT NULL,
  `Content_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Content_id`),
  INDEX `fk_Subscription_Content1_idx` (`Content_id` ASC) VISIBLE,
  CONSTRAINT `fk_Subscription_Content1`
    FOREIGN KEY (`Content_id`)
    REFERENCES `my_db`.`Content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`Account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Account` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Account` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `settings` TEXT NULL DEFAULT NULL,
  `name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`AccountSubscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`AccountSubscription` ;

CREATE TABLE IF NOT EXISTS `my_db`.`AccountSubscription` (
  `Subscription_id` INT UNSIGNED NOT NULL,
  `Subscription_Content_id` INT UNSIGNED NOT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Subscription_id`, `Subscription_Content_id`, `Account_id`),
  INDEX `fk_AccountSubscription_Subscription1_idx` (`Subscription_id` ASC, `Subscription_Content_id` ASC) VISIBLE,
  INDEX `fk_AccountSubscription_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_AccountSubscription_Subscription1`
    FOREIGN KEY (`Subscription_id`, `Subscription_Content_id`)
    REFERENCES `my_db`.`Subscription` (`id`, `Content_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AccountSubscription_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `my_db`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`Group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Group` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Group` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `info` TEXT NULL DEFAULT NULL,
  `label` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`AccountGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`AccountGroup` ;

CREATE TABLE IF NOT EXISTS `my_db`.`AccountGroup` (
  `Group_id` INT UNSIGNED NOT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Group_id`, `Account_id`),
  INDEX `fk_AccountGroup_Group1_idx` (`Group_id` ASC) VISIBLE,
  INDEX `fk_AccountGroup_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_AccountGroup_Group1`
    FOREIGN KEY (`Group_id`)
    REFERENCES `my_db`.`Group` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AccountGroup_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `my_db`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`TaskScript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`TaskScript` ;

CREATE TABLE IF NOT EXISTS `my_db`.`TaskScript` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `defenition` TEXT NULL DEFAULT NULL,
  `created` DATETIME NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`Session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Session` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Session` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NULL DEFAULT NULL,
  `Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Account_id`),
  INDEX `fk_Session_Account1_idx` (`Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_Session_Account1`
    FOREIGN KEY (`Account_id`)
    REFERENCES `my_db`.`Account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`SessionScriptLink`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`SessionScriptLink` ;

CREATE TABLE IF NOT EXISTS `my_db`.`SessionScriptLink` (
  `script_id` INT UNSIGNED NOT NULL,
  `TaskScript_id` INT UNSIGNED NOT NULL,
  `Session_id` INT UNSIGNED NOT NULL,
  `Session_Account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`script_id`, `TaskScript_id`, `Session_id`, `Session_Account_id`),
  INDEX `fk_SesstionScriptLink_TaskScript1_idx` (`TaskScript_id` ASC) VISIBLE,
  INDEX `fk_SesstionScriptLink_Session1_idx` (`Session_id` ASC, `Session_Account_id` ASC) VISIBLE,
  CONSTRAINT `fk_SesstionScriptLink_TaskScript1`
    FOREIGN KEY (`TaskScript_id`)
    REFERENCES `my_db`.`TaskScript` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SesstionScriptLink_Session1`
    FOREIGN KEY (`Session_id`, `Session_Account_id`)
    REFERENCES `my_db`.`Session` (`id`, `Account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`Result`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`Result` ;

CREATE TABLE IF NOT EXISTS `my_db`.`Result` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `session` INT UNSIGNED NOT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  `score` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `my_db`.`SessionResultLink`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `my_db`.`SessionResultLink` ;

CREATE TABLE IF NOT EXISTS `my_db`.`SessionResultLink` (
  `Session_id` INT UNSIGNED NOT NULL,
  `Session_Account_id` INT UNSIGNED NOT NULL,
  `Result_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Session_id`, `Session_Account_id`, `Result_id`),
  INDEX `fk_SessionResultLink_Session1_idx` (`Session_id` ASC, `Session_Account_id` ASC) VISIBLE,
  INDEX `fk_SessionResultLink_Result1_idx` (`Result_id` ASC) VISIBLE,
  CONSTRAINT `fk_SessionResultLink_Session1`
    FOREIGN KEY (`Session_id`, `Session_Account_id`)
    REFERENCES `my_db`.`Session` (`id`, `Account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SessionResultLink_Result1`
    FOREIGN KEY (`Result_id`)
    REFERENCES `my_db`.`Result` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Зміна режимів назад
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
