CREATE TABLE `data_change_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `action` VARCHAR(50) NOT NULL,
  `table` VARCHAR(100) NOT NULL,
  `column` VARCHAR(100) NOT NULL,
  `newValue` LONGTEXT NULL DEFAULT NULL,
  `oldValue` LONGTEXT NULL DEFAULT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `system` VARCHAR(50) NOT NULL,
  `columnReference` VARCHAR(100) NULL DEFAULT NULL,
  `operatorReference` VARCHAR(50) NULL DEFAULT NULL,
  `valueReference` VARCHAR(50) NULL DEFAULT NULL,
  `userId` INT UNSIGNED NOT NULL,
  `ip` VARCHAR(50) NOT NULL,
  `userAgent` TEXT NOT NULL,
  PRIMARY KEY (`id`)
)
  COLLATE='utf8mb4_general_ci'
  ENGINE=InnoDB
;

ALTER TABLE `data_change_log`
  ADD COLUMN `groupId` INT(11) UNSIGNED NOT NULL DEFAULT '0' AFTER `userAgent`;

ALTER TABLE `data_change_log`
  ADD INDEX `table_name` (`table`),
  ADD INDEX `column_name` (`column`),
  ADD INDEX `references` (`columnReference`, `valueReference`),
  ADD INDEX `date` (`date`),
  ADD INDEX `groupId` (`groupId`);

#Example
select *
from data_change_log dcl
where (dcl.`table` = 'campaign_data' and dcl.columnReference='id' and dcl.valueReference=136)
      OR dcl.groupId in (
  select dcl2.id
  from data_change_log dcl2
  where dcl2.`table`='country_campaign_data' and dcl2.`column`='campaignDataId'
        and (dcl2.newValue = 136 or dcl2.oldValue=136)
)
order by id desc