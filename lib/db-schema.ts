// Generated from the DKKT Prisma data contract. Keep this allowlist in sync with database/schema.mariadb.sql.
export const DB_MODELS = {
  "User": {
    "table": "user",
    "columns": [
      "id",
      "artistId",
      "name",
      "username",
      "email",
      "passwordHash",
      "status",
      "lastLoginAt",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "lastLoginAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "Role": {
    "table": "role",
    "columns": [
      "id",
      "name",
      "description",
      "isSystem",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isSystem"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "Permission": {
    "table": "permission",
    "columns": [
      "id",
      "name",
      "description",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "UserRole": {
    "table": "userRole",
    "columns": [
      "userId",
      "roleId"
    ],
    "primaryKey": [
      "userId",
      "roleId"
    ],
    "booleanColumns": [],
    "dateTimeColumns": []
  },
  "RolePermission": {
    "table": "rolePermission",
    "columns": [
      "roleId",
      "permissionId"
    ],
    "primaryKey": [
      "roleId",
      "permissionId"
    ],
    "booleanColumns": [],
    "dateTimeColumns": []
  },
  "Committee": {
    "table": "committee",
    "columns": [
      "id",
      "name",
      "slug",
      "shortName",
      "description",
      "icon",
      "coverImage",
      "chairman",
      "chairmanArtistId",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "CommitteeMember": {
    "table": "committeeMember",
    "columns": [
      "id",
      "committeeId",
      "name",
      "position",
      "photo",
      "biography",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "CommitteeUser": {
    "table": "committeeUser",
    "columns": [
      "userId",
      "committeeId",
      "accessLevel",
      "createdAt"
    ],
    "primaryKey": [
      "userId",
      "committeeId"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt"
    ]
  },
  "NewsCategory": {
    "table": "newsCategory",
    "columns": [
      "id",
      "name",
      "slug",
      "description",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "News": {
    "table": "news",
    "columns": [
      "id",
      "title",
      "slug",
      "subtitle",
      "excerpt",
      "content",
      "featuredImage",
      "status",
      "isFeatured",
      "isPublished",
      "categoryId",
      "committeeId",
      "createdById",
      "updatedById",
      "publishedById",
      "publishedAt",
      "rejectionReason",
      "rejectedById",
      "rejectedAt",
      "reviewedById",
      "reviewedAt",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isFeatured",
      "isPublished"
    ],
    "dateTimeColumns": [
      "publishedAt",
      "rejectedAt",
      "reviewedAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "NewsWorkflowLog": {
    "table": "newsWorkflowLog",
    "columns": [
      "id",
      "newsId",
      "actorId",
      "action",
      "note",
      "createdAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt"
    ]
  },
  "AgendaCategory": {
    "table": "agendaCategory",
    "columns": [
      "id",
      "name",
      "slug",
      "description",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "Agenda": {
    "table": "agenda",
    "columns": [
      "id",
      "title",
      "slug",
      "description",
      "excerpt",
      "image",
      "status",
      "isFeatured",
      "isPublished",
      "committeeId",
      "categoryId",
      "startDate",
      "endDate",
      "startTime",
      "endTime",
      "location",
      "address",
      "registrationUrl",
      "registrationText",
      "contactName",
      "contactPhone",
      "contactEmail",
      "organizer",
      "target",
      "notes",
      "createdById",
      "updatedById",
      "publishedById",
      "publishedAt",
      "rejectionReason",
      "rejectedById",
      "rejectedAt",
      "reviewedById",
      "reviewedAt",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isFeatured",
      "isPublished"
    ],
    "dateTimeColumns": [
      "startDate",
      "endDate",
      "publishedAt",
      "rejectedAt",
      "reviewedAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "AgendaWorkflowLog": {
    "table": "agendaWorkflowLog",
    "columns": [
      "id",
      "agendaId",
      "actorId",
      "action",
      "note",
      "createdAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt"
    ]
  },
  "MediaFile": {
    "table": "mediaFile",
    "columns": [
      "id",
      "filename",
      "originalName",
      "mimeType",
      "size",
      "url",
      "thumbnailUrl",
      "altText",
      "caption",
      "folder",
      "width",
      "height",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "GalleryAlbum": {
    "table": "galleryAlbum",
    "columns": [
      "id",
      "title",
      "slug",
      "description",
      "coverImage",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "GalleryItem": {
    "table": "galleryItem",
    "columns": [
      "id",
      "albumId",
      "committeeId",
      "mediaId",
      "type",
      "title",
      "description",
      "fileUrl",
      "thumbnailUrl",
      "externalUrl",
      "mimeType",
      "width",
      "height",
      "duration",
      "eventDate",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "eventDate",
      "createdAt",
      "updatedAt"
    ]
  },
  "Document": {
    "table": "document",
    "columns": [
      "id",
      "title",
      "documentNumber",
      "documentType",
      "description",
      "fileUrl",
      "fileName",
      "mimeType",
      "fileSize",
      "isPublished",
      "sortOrder",
      "publishedAt",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isPublished"
    ],
    "dateTimeColumns": [
      "publishedAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "OrganizationSection": {
    "table": "organizationSection",
    "columns": [
      "id",
      "name",
      "slug",
      "description",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "OrganizationMember": {
    "table": "organizationMember",
    "columns": [
      "id",
      "sectionId",
      "artistId",
      "name",
      "position",
      "photo",
      "biography",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "Artist": {
    "table": "artist",
    "columns": [
      "id",
      "registrationNumber",
      "registrationStatus",
      "name",
      "slug",
      "committeeId",
      "discipline",
      "biography",
      "photo",
      "email",
      "phone",
      "website",
      "birthPlace",
      "birthDate",
      "gender",
      "address",
      "skNumber",
      "skDate",
      "skFileUrl",
      "cardIssuedAt",
      "cardFileUrl",
      "sortOrder",
      "isFeatured",
      "isActive",
      "registeredAt",
      "verifiedAt",
      "verifiedBy",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isFeatured",
      "isActive"
    ],
    "dateTimeColumns": [
      "birthDate",
      "skDate",
      "cardIssuedAt",
      "registeredAt",
      "verifiedAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "CulturalGroup": {
    "table": "culturalGroup",
    "columns": [
      "id",
      "registrationNumber",
      "registrationStatus",
      "name",
      "slug",
      "committeeId",
      "groupType",
      "description",
      "leader",
      "address",
      "email",
      "phone",
      "website",
      "logo",
      "establishedDate",
      "memberCount",
      "skNumber",
      "skDate",
      "skFileUrl",
      "cardIssuedAt",
      "cardFileUrl",
      "sortOrder",
      "isFeatured",
      "isActive",
      "registeredAt",
      "verifiedAt",
      "verifiedBy",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isFeatured",
      "isActive"
    ],
    "dateTimeColumns": [
      "establishedDate",
      "skDate",
      "cardIssuedAt",
      "registeredAt",
      "verifiedAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "RegistrationSequence": {
    "table": "registrationSequence",
    "columns": [
      "id",
      "scopeKey",
      "category",
      "committeeId",
      "year",
      "lastNumber",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "SitePage": {
    "table": "sitePage",
    "columns": [
      "id",
      "title",
      "slug",
      "excerpt",
      "content",
      "featuredImage",
      "status",
      "isPublished",
      "seoTitle",
      "seoDescription",
      "seoKeywords",
      "createdById",
      "updatedById",
      "publishedById",
      "publishedAt",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isPublished"
    ],
    "dateTimeColumns": [
      "publishedAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "HomeHighlight": {
    "table": "homeHighlight",
    "columns": [
      "id",
      "title",
      "subtitle",
      "description",
      "imageUrl",
      "linkUrl",
      "sortOrder",
      "isActive",
      "startAt",
      "endAt",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "startAt",
      "endAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "SiteSetting": {
    "table": "siteSetting",
    "columns": [
      "id",
      "key",
      "value",
      "description",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "SocialLink": {
    "table": "socialLink",
    "columns": [
      "id",
      "platform",
      "label",
      "url",
      "icon",
      "sortOrder",
      "isActive",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [
      "isActive"
    ],
    "dateTimeColumns": [
      "createdAt",
      "updatedAt"
    ]
  },
  "ContactMessage": {
    "table": "contactMessage",
    "columns": [
      "id",
      "name",
      "email",
      "phone",
      "subject",
      "message",
      "status",
      "repliedAt",
      "repliedBy",
      "createdAt",
      "updatedAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "repliedAt",
      "createdAt",
      "updatedAt"
    ]
  },
  "AuditLog": {
    "table": "auditLog",
    "columns": [
      "id",
      "userId",
      "action",
      "entity",
      "entityId",
      "message",
      "ipAddress",
      "userAgent",
      "createdAt"
    ],
    "primaryKey": [
      "id"
    ],
    "booleanColumns": [],
    "dateTimeColumns": [
      "createdAt"
    ]
  }
} as const;

export type DbModelName = keyof typeof DB_MODELS;
