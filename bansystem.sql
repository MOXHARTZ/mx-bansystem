CREATE TABLE `bannedplayers` (
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`steam` VARCHAR(60) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`admin` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`rockstar` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`xbox` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`live` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`discord` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`ip` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`reason` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`time` INT(30) NULL DEFAULT NULL,
	PRIMARY KEY (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;