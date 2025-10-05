CREATE TABLE IF NOT EXISTS `weapon_racks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_identifier` varchar(64) NOT NULL,
  `owner_charid` int(11) NOT NULL,
  `x` double NOT NULL,
  `y` double NOT NULL,
  `z` double NOT NULL,
  `heading` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

INSERT IGNORE INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `metadata`, `desc`, `weight`) VALUES
("weapons_rack", "Weapons Rack", 200, 1, "item_standard", 1, "{}", "It is used to keep weapons organized", 0.1);