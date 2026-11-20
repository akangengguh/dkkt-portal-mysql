-- DKKT Portal MariaDB schema generated from the original PostgreSQL data contract.
-- Target: Hostinger Web/Cloud Hosting (MariaDB). No DROP statements are included.
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `user` (
  `id` VARCHAR(191) NOT NULL,
  `artistId` VARCHAR(191) NULL,
  `name` VARCHAR(191) NOT NULL,
  `username` VARCHAR(191) NULL,
  `email` VARCHAR(191) NOT NULL,
  `passwordHash` VARCHAR(191) NOT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'ACTIVE',
  `lastLoginAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_artistId_uk` (`artistId`),
  UNIQUE KEY `idx_user_username_uk` (`username`),
  UNIQUE KEY `idx_user_email_uk` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `role` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `isSystem` TINYINT(1) NOT NULL DEFAULT 0,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_role_name_uk` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `permission` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_permission_name_uk` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `userRole` (
  `userId` VARCHAR(191) NOT NULL,
  `roleId` VARCHAR(191) NOT NULL,
  PRIMARY KEY (`userId`, `roleId`),
  KEY `idx_userRole_roleId_idx` (`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rolePermission` (
  `roleId` VARCHAR(191) NOT NULL,
  `permissionId` VARCHAR(191) NOT NULL,
  PRIMARY KEY (`roleId`, `permissionId`),
  KEY `idx_rolePermission_permissionId_idx` (`permissionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `committee` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `shortName` VARCHAR(191) NULL,
  `description` LONGTEXT NULL,
  `icon` VARCHAR(191) NULL,
  `coverImage` TEXT NULL,
  `chairman` VARCHAR(191) NULL,
  `chairmanArtistId` VARCHAR(191) NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_committee_slug_uk` (`slug`),
  KEY `idx_committee_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `committeeMember` (
  `id` VARCHAR(191) NOT NULL,
  `committeeId` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `position` VARCHAR(191) NOT NULL,
  `photo` TEXT NULL,
  `biography` LONGTEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_committeeMember_committeeId_idx` (`committeeId`),
  KEY `idx_committeeMember_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `committeeUser` (
  `userId` VARCHAR(191) NOT NULL,
  `committeeId` VARCHAR(191) NOT NULL,
  `accessLevel` VARCHAR(191) NOT NULL DEFAULT 'EDITOR',
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`userId`, `committeeId`),
  KEY `idx_committeeUser_committeeId_idx` (`committeeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `newsCategory` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_newsCategory_slug_uk` (`slug`),
  KEY `idx_newsCategory_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `news` (
  `id` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `subtitle` LONGTEXT NULL,
  `excerpt` LONGTEXT NULL,
  `content` LONGTEXT NOT NULL,
  `featuredImage` TEXT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'DRAFT',
  `isFeatured` TINYINT(1) NOT NULL DEFAULT 0,
  `isPublished` TINYINT(1) NOT NULL DEFAULT 0,
  `categoryId` VARCHAR(191) NULL,
  `committeeId` VARCHAR(191) NULL,
  `createdById` VARCHAR(191) NOT NULL,
  `updatedById` VARCHAR(191) NULL,
  `publishedById` VARCHAR(191) NULL,
  `publishedAt` DATETIME(3) NULL,
  `rejectionReason` LONGTEXT NULL,
  `rejectedById` VARCHAR(191) NULL,
  `rejectedAt` DATETIME(3) NULL,
  `reviewedById` VARCHAR(191) NULL,
  `reviewedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_news_slug_uk` (`slug`),
  KEY `idx_news_status_idx` (`status`),
  KEY `idx_news_committeeId_idx` (`committeeId`),
  KEY `idx_news_categoryId_idx` (`categoryId`),
  KEY `idx_news_publishedAt_idx` (`publishedAt`),
  KEY `idx_news_isFeatured_idx` (`isFeatured`),
  KEY `idx_news_rejectedById_idx` (`rejectedById`),
  KEY `idx_news_reviewedById_idx` (`reviewedById`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `newsWorkflowLog` (
  `id` VARCHAR(191) NOT NULL,
  `newsId` VARCHAR(191) NOT NULL,
  `actorId` VARCHAR(191) NOT NULL,
  `action` VARCHAR(191) NOT NULL,
  `note` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_newsWorkflowLog_newsId_idx` (`newsId`),
  KEY `idx_newsWorkflowLog_actorId_idx` (`actorId`),
  KEY `idx_newsWorkflowLog_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `agendaCategory` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_agendaCategory_slug_uk` (`slug`),
  KEY `idx_agendaCategory_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `agenda` (
  `id` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NOT NULL,
  `excerpt` LONGTEXT NULL,
  `image` TEXT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'DRAFT',
  `isFeatured` TINYINT(1) NOT NULL DEFAULT 0,
  `isPublished` TINYINT(1) NOT NULL DEFAULT 0,
  `committeeId` VARCHAR(191) NULL,
  `categoryId` VARCHAR(191) NULL,
  `startDate` DATETIME(3) NOT NULL,
  `endDate` DATETIME(3) NULL,
  `startTime` VARCHAR(191) NULL,
  `endTime` VARCHAR(191) NULL,
  `location` VARCHAR(191) NULL,
  `address` LONGTEXT NULL,
  `registrationUrl` VARCHAR(191) NULL,
  `registrationText` LONGTEXT NULL,
  `contactName` VARCHAR(191) NULL,
  `contactPhone` VARCHAR(191) NULL,
  `contactEmail` VARCHAR(191) NULL,
  `organizer` VARCHAR(191) NULL,
  `target` LONGTEXT NULL,
  `notes` LONGTEXT NULL,
  `createdById` VARCHAR(191) NOT NULL,
  `updatedById` VARCHAR(191) NULL,
  `publishedById` VARCHAR(191) NULL,
  `publishedAt` DATETIME(3) NULL,
  `rejectionReason` LONGTEXT NULL,
  `rejectedById` VARCHAR(191) NULL,
  `rejectedAt` DATETIME(3) NULL,
  `reviewedById` VARCHAR(191) NULL,
  `reviewedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_agenda_slug_uk` (`slug`),
  KEY `idx_agenda_status_idx` (`status`),
  KEY `idx_agenda_committeeId_idx` (`committeeId`),
  KEY `idx_agenda_categoryId_idx` (`categoryId`),
  KEY `idx_agenda_startDate_idx` (`startDate`),
  KEY `idx_agenda_isFeatured_idx` (`isFeatured`),
  KEY `idx_agenda_rejectedById_idx` (`rejectedById`),
  KEY `idx_agenda_reviewedById_idx` (`reviewedById`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `agendaWorkflowLog` (
  `id` VARCHAR(191) NOT NULL,
  `agendaId` VARCHAR(191) NOT NULL,
  `actorId` VARCHAR(191) NOT NULL,
  `action` VARCHAR(191) NOT NULL,
  `note` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_agendaWorkflowLog_agendaId_idx` (`agendaId`),
  KEY `idx_agendaWorkflowLog_actorId_idx` (`actorId`),
  KEY `idx_agendaWorkflowLog_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `mediaFile` (
  `id` VARCHAR(191) NOT NULL,
  `filename` VARCHAR(191) NOT NULL,
  `originalName` VARCHAR(191) NOT NULL,
  `mimeType` VARCHAR(191) NOT NULL,
  `size` INT NOT NULL,
  `url` TEXT NOT NULL,
  `thumbnailUrl` TEXT NULL,
  `altText` LONGTEXT NULL,
  `caption` LONGTEXT NULL,
  `folder` VARCHAR(191) NULL,
  `width` INT NULL,
  `height` INT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_mediaFile_mimeType_idx` (`mimeType`),
  KEY `idx_mediaFile_folder_idx` (`folder`),
  KEY `idx_mediaFile_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `galleryAlbum` (
  `id` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `coverImage` TEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_galleryAlbum_slug_uk` (`slug`),
  KEY `idx_galleryAlbum_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `galleryItem` (
  `id` VARCHAR(191) NOT NULL,
  `albumId` VARCHAR(191) NOT NULL,
  `committeeId` VARCHAR(191) NULL,
  `mediaId` VARCHAR(191) NULL,
  `type` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `fileUrl` TEXT NULL,
  `thumbnailUrl` TEXT NULL,
  `externalUrl` TEXT NULL,
  `mimeType` VARCHAR(191) NULL,
  `width` INT NULL,
  `height` INT NULL,
  `duration` INT NULL,
  `eventDate` DATETIME(3) NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_galleryItem_albumId_sortOrder_idx` (`albumId`, `sortOrder`),
  KEY `idx_galleryItem_committeeId_idx` (`committeeId`),
  KEY `idx_galleryItem_mediaId_idx` (`mediaId`),
  KEY `idx_galleryItem_type_idx` (`type`),
  KEY `idx_galleryItem_eventDate_idx` (`eventDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `document` (
  `id` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `documentNumber` VARCHAR(191) NULL,
  `documentType` VARCHAR(191) NULL,
  `description` LONGTEXT NULL,
  `fileUrl` TEXT NOT NULL,
  `fileName` TEXT NULL,
  `mimeType` VARCHAR(191) NULL,
  `fileSize` INT NULL,
  `isPublished` TINYINT(1) NOT NULL DEFAULT 0,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `publishedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_document_documentType_idx` (`documentType`),
  KEY `idx_document_isPublished_sortOrder_idx` (`isPublished`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `organizationSection` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_organizationSection_slug_uk` (`slug`),
  KEY `idx_organizationSection_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `organizationMember` (
  `id` VARCHAR(191) NOT NULL,
  `sectionId` VARCHAR(191) NOT NULL,
  `artistId` VARCHAR(191) NULL,
  `name` VARCHAR(191) NOT NULL,
  `position` VARCHAR(191) NOT NULL,
  `photo` TEXT NULL,
  `biography` LONGTEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_organizationMember_sectionId_idx` (`sectionId`),
  KEY `idx_organizationMember_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `artist` (
  `id` VARCHAR(191) NOT NULL,
  `registrationNumber` VARCHAR(191) NOT NULL,
  `registrationStatus` VARCHAR(191) NOT NULL DEFAULT 'PENDING',
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `committeeId` VARCHAR(191) NULL,
  `discipline` VARCHAR(191) NULL,
  `biography` LONGTEXT NULL,
  `photo` TEXT NULL,
  `email` VARCHAR(191) NULL,
  `phone` VARCHAR(191) NULL,
  `website` TEXT NULL,
  `birthPlace` VARCHAR(191) NULL,
  `birthDate` DATETIME(3) NULL,
  `gender` VARCHAR(191) NULL,
  `address` LONGTEXT NULL,
  `skNumber` VARCHAR(191) NULL,
  `skDate` DATETIME(3) NULL,
  `skFileUrl` TEXT NULL,
  `cardIssuedAt` DATETIME(3) NULL,
  `cardFileUrl` TEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isFeatured` TINYINT(1) NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `registeredAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `verifiedAt` DATETIME(3) NULL,
  `verifiedBy` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_artist_registrationNumber_uk` (`registrationNumber`),
  UNIQUE KEY `idx_artist_slug_uk` (`slug`),
  KEY `idx_artist_isActive_sortOrder_idx` (`isActive`, `sortOrder`),
  KEY `idx_artist_discipline_idx` (`discipline`),
  KEY `idx_artist_committeeId_registrationStatus_idx` (`committeeId`, `registrationStatus`),
  KEY `idx_artist_registrationStatus_registeredAt_idx` (`registrationStatus`, `registeredAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `culturalGroup` (
  `id` VARCHAR(191) NOT NULL,
  `registrationNumber` VARCHAR(191) NOT NULL,
  `registrationStatus` VARCHAR(191) NOT NULL DEFAULT 'PENDING',
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `committeeId` VARCHAR(191) NULL,
  `groupType` VARCHAR(191) NOT NULL DEFAULT 'SANGGAR',
  `description` LONGTEXT NULL,
  `leader` VARCHAR(191) NULL,
  `address` LONGTEXT NULL,
  `email` VARCHAR(191) NULL,
  `phone` VARCHAR(191) NULL,
  `website` TEXT NULL,
  `logo` TEXT NULL,
  `establishedDate` DATETIME(3) NULL,
  `memberCount` INT NULL,
  `skNumber` VARCHAR(191) NULL,
  `skDate` DATETIME(3) NULL,
  `skFileUrl` TEXT NULL,
  `cardIssuedAt` DATETIME(3) NULL,
  `cardFileUrl` TEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isFeatured` TINYINT(1) NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `registeredAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `verifiedAt` DATETIME(3) NULL,
  `verifiedBy` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_culturalGroup_registrationNumber_uk` (`registrationNumber`),
  UNIQUE KEY `idx_culturalGroup_slug_uk` (`slug`),
  KEY `idx_culturalGroup_isActive_sortOrder_idx` (`isActive`, `sortOrder`),
  KEY `idx_culturalGroup_groupType_idx` (`groupType`),
  KEY `idx_culturalGroup_committeeId_registrationStatus_idx` (`committeeId`, `registrationStatus`),
  KEY `idx_culturalGroup_registrationStatus_registeredAt_idx` (`registrationStatus`, `registeredAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `registrationSequence` (
  `id` VARCHAR(191) NOT NULL,
  `scopeKey` VARCHAR(191) NOT NULL,
  `category` VARCHAR(191) NOT NULL,
  `committeeId` VARCHAR(191) NULL,
  `year` INT NOT NULL,
  `lastNumber` INT NOT NULL DEFAULT 0,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_registrationSequence_scopeKey_uk` (`scopeKey`),
  KEY `idx_registrationSequence_category_committeeId_year_idx` (`category`, `committeeId`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sitePage` (
  `id` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `excerpt` LONGTEXT NULL,
  `content` LONGTEXT NOT NULL,
  `featuredImage` TEXT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'DRAFT',
  `isPublished` TINYINT(1) NOT NULL DEFAULT 0,
  `seoTitle` VARCHAR(191) NULL,
  `seoDescription` LONGTEXT NULL,
  `seoKeywords` LONGTEXT NULL,
  `createdById` VARCHAR(191) NOT NULL,
  `updatedById` VARCHAR(191) NULL,
  `publishedById` VARCHAR(191) NULL,
  `publishedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_sitePage_slug_uk` (`slug`),
  KEY `idx_sitePage_status_idx` (`status`),
  KEY `idx_sitePage_isPublished_idx` (`isPublished`),
  KEY `idx_sitePage_publishedAt_idx` (`publishedAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `homeHighlight` (
  `id` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `subtitle` LONGTEXT NULL,
  `description` LONGTEXT NULL,
  `imageUrl` TEXT NOT NULL,
  `linkUrl` TEXT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `startAt` DATETIME(3) NULL,
  `endAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_homeHighlight_isActive_sortOrder_idx` (`isActive`, `sortOrder`),
  KEY `idx_homeHighlight_startAt_endAt_idx` (`startAt`, `endAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `siteSetting` (
  `id` VARCHAR(191) NOT NULL,
  `key` VARCHAR(191) NOT NULL,
  `value` VARCHAR(191) NOT NULL,
  `description` LONGTEXT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_siteSetting_key_uk` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `socialLink` (
  `id` VARCHAR(191) NOT NULL,
  `platform` VARCHAR(191) NOT NULL,
  `label` VARCHAR(191) NOT NULL,
  `url` TEXT NOT NULL,
  `icon` VARCHAR(191) NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_socialLink_isActive_sortOrder_idx` (`isActive`, `sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `contactMessage` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `email` VARCHAR(191) NOT NULL,
  `phone` VARCHAR(191) NULL,
  `subject` VARCHAR(191) NOT NULL,
  `message` LONGTEXT NOT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'UNREAD',
  `repliedAt` DATETIME(3) NULL,
  `repliedBy` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_contactMessage_status_idx` (`status`),
  KEY `idx_contactMessage_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `auditLog` (
  `id` VARCHAR(191) NOT NULL,
  `userId` VARCHAR(191) NULL,
  `action` VARCHAR(191) NOT NULL,
  `entity` VARCHAR(191) NOT NULL,
  `entityId` VARCHAR(191) NULL,
  `message` LONGTEXT NULL,
  `ipAddress` VARCHAR(191) NULL,
  `userAgent` LONGTEXT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_auditLog_userId_idx` (`userId`),
  KEY `idx_auditLog_entity_entityId_idx` (`entity`, `entityId`),
  KEY `idx_auditLog_action_idx` (`action`),
  KEY `idx_auditLog_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `user` ADD CONSTRAINT `fk_user_artistId` FOREIGN KEY (`artistId`) REFERENCES `artist` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `userRole` ADD CONSTRAINT `fk_userRole_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `userRole` ADD CONSTRAINT `fk_userRole_roleId` FOREIGN KEY (`roleId`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `rolePermission` ADD CONSTRAINT `fk_rolePermission_roleId` FOREIGN KEY (`roleId`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `rolePermission` ADD CONSTRAINT `fk_rolePermission_permissionId` FOREIGN KEY (`permissionId`) REFERENCES `permission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `committee` ADD CONSTRAINT `fk_committee_chairmanArtistId` FOREIGN KEY (`chairmanArtistId`) REFERENCES `artist` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `committeeMember` ADD CONSTRAINT `fk_committeeMember_committeeId` FOREIGN KEY (`committeeId`) REFERENCES `committee` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `committeeUser` ADD CONSTRAINT `fk_committeeUser_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `committeeUser` ADD CONSTRAINT `fk_committeeUser_committeeId` FOREIGN KEY (`committeeId`) REFERENCES `committee` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `news` ADD CONSTRAINT `fk_news_categoryId` FOREIGN KEY (`categoryId`) REFERENCES `newsCategory` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `news` ADD CONSTRAINT `fk_news_committeeId` FOREIGN KEY (`committeeId`) REFERENCES `committee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `news` ADD CONSTRAINT `fk_news_createdById` FOREIGN KEY (`createdById`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `news` ADD CONSTRAINT `fk_news_updatedById` FOREIGN KEY (`updatedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `news` ADD CONSTRAINT `fk_news_publishedById` FOREIGN KEY (`publishedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `news` ADD CONSTRAINT `fk_news_rejectedById` FOREIGN KEY (`rejectedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `news` ADD CONSTRAINT `fk_news_reviewedById` FOREIGN KEY (`reviewedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `newsWorkflowLog` ADD CONSTRAINT `fk_newsWorkflowLog_newsId` FOREIGN KEY (`newsId`) REFERENCES `news` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `newsWorkflowLog` ADD CONSTRAINT `fk_newsWorkflowLog_actorId` FOREIGN KEY (`actorId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `agenda` ADD CONSTRAINT `fk_agenda_committeeId` FOREIGN KEY (`committeeId`) REFERENCES `committee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `agenda` ADD CONSTRAINT `fk_agenda_categoryId` FOREIGN KEY (`categoryId`) REFERENCES `agendaCategory` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `agenda` ADD CONSTRAINT `fk_agenda_createdById` FOREIGN KEY (`createdById`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `agenda` ADD CONSTRAINT `fk_agenda_updatedById` FOREIGN KEY (`updatedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `agenda` ADD CONSTRAINT `fk_agenda_publishedById` FOREIGN KEY (`publishedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `agenda` ADD CONSTRAINT `fk_agenda_rejectedById` FOREIGN KEY (`rejectedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `agenda` ADD CONSTRAINT `fk_agenda_reviewedById` FOREIGN KEY (`reviewedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `agendaWorkflowLog` ADD CONSTRAINT `fk_agendaWorkflowLog_agendaId` FOREIGN KEY (`agendaId`) REFERENCES `agenda` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `agendaWorkflowLog` ADD CONSTRAINT `fk_agendaWorkflowLog_actorId` FOREIGN KEY (`actorId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `galleryItem` ADD CONSTRAINT `fk_galleryItem_albumId` FOREIGN KEY (`albumId`) REFERENCES `galleryAlbum` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `galleryItem` ADD CONSTRAINT `fk_galleryItem_committeeId` FOREIGN KEY (`committeeId`) REFERENCES `committee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `galleryItem` ADD CONSTRAINT `fk_galleryItem_mediaId` FOREIGN KEY (`mediaId`) REFERENCES `mediaFile` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `organizationMember` ADD CONSTRAINT `fk_organizationMember_sectionId` FOREIGN KEY (`sectionId`) REFERENCES `organizationSection` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `organizationMember` ADD CONSTRAINT `fk_organizationMember_artistId` FOREIGN KEY (`artistId`) REFERENCES `artist` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `artist` ADD CONSTRAINT `fk_artist_committeeId` FOREIGN KEY (`committeeId`) REFERENCES `committee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `culturalGroup` ADD CONSTRAINT `fk_culturalGroup_committeeId` FOREIGN KEY (`committeeId`) REFERENCES `committee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `sitePage` ADD CONSTRAINT `fk_sitePage_createdById` FOREIGN KEY (`createdById`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `sitePage` ADD CONSTRAINT `fk_sitePage_updatedById` FOREIGN KEY (`updatedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `sitePage` ADD CONSTRAINT `fk_sitePage_publishedById` FOREIGN KEY (`publishedById`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `auditLog` ADD CONSTRAINT `fk_auditLog_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

