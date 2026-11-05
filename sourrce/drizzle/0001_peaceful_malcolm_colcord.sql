CREATE TABLE `org_tag_groups` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`name` text NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `sequence_steps` (
	`id` text PRIMARY KEY NOT NULL,
	`sequence_id` text NOT NULL,
	`delay_value` integer NOT NULL,
	`delay_unit` text NOT NULL,
	`type` text DEFAULT 'text' NOT NULL,
	`content` text,
	`block_id` text,
	`order` integer NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	`updated_at` integer DEFAULT 0,
	FOREIGN KEY (`sequence_id`) REFERENCES `sequences`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`block_id`) REFERENCES `message_blocks`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `sequence_subscribers` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`contact_id` text NOT NULL,
	`sequence_id` text NOT NULL,
	`zalo_account_id` text NOT NULL,
	`status` text DEFAULT 'active' NOT NULL,
	`current_step_order` integer DEFAULT 0 NOT NULL,
	`next_scheduled_at` integer,
	`last_sent_at` integer,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	`updated_at` integer DEFAULT 0,
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`contact_id`) REFERENCES `contacts`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`sequence_id`) REFERENCES `sequences`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`zalo_account_id`) REFERENCES `zalo_accounts`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `sequence_subscribers_unq` ON `sequence_subscribers` (`contact_id`,`sequence_id`);--> statement-breakpoint
CREATE TABLE `sequences` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`name` text NOT NULL,
	`description` text,
	`tag_id` text,
	`enabled` integer DEFAULT true NOT NULL,
	`quiet_start` text,
	`quiet_end` text,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	`updated_at` integer DEFAULT 0,
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `student_file_cohort_runs` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`student_file_id` text NOT NULL,
	`cohort_campaign_id` text NOT NULL,
	`name` text NOT NULL,
	`start_date` integer,
	`status` text DEFAULT 'active' NOT NULL,
	`zalo_group_ids` text DEFAULT '[]' NOT NULL,
	`group_logs` text DEFAULT '{}' NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`student_file_id`) REFERENCES `student_files`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`cohort_campaign_id`) REFERENCES `webinar_campaigns`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `student_file_subscribers` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`student_file_id` text NOT NULL,
	`cohort_run_id` text,
	`contact_id` text NOT NULL,
	`zalo_uid` text,
	`friend_request_sent` integer DEFAULT false,
	`joined_group` integer DEFAULT false,
	`assigned_zalo_group_id` text,
	`message_logs` text DEFAULT '{}' NOT NULL,
	`engagement_data` text DEFAULT '{}' NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`student_file_id`) REFERENCES `student_files`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`cohort_run_id`) REFERENCES `student_file_cohort_runs`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`contact_id`) REFERENCES `contacts`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `student_files` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`name` text NOT NULL,
	`zalo_account_id` text NOT NULL,
	`invite_message` text DEFAULT 'Chào [Name], mình kết bạn để gửi thông tin khóa học nhé!' NOT NULL,
	`welcome_messages` text DEFAULT '[]' NOT NULL,
	`webhook_token` text NOT NULL,
	`tags` text DEFAULT '[]' NOT NULL,
	`status` text DEFAULT 'active' NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	`updated_at` integer DEFAULT 0,
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`zalo_account_id`) REFERENCES `zalo_accounts`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `student_files_webhook_token_unique` ON `student_files` (`webhook_token`);--> statement-breakpoint
CREATE TABLE `webinar_campaign_groups` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`campaign_id` text NOT NULL,
	`cohort_day_id` text,
	`zalo_group_id` text NOT NULL,
	`group_name` text NOT NULL,
	`group_invite_link` text,
	`max_members` integer DEFAULT 500 NOT NULL,
	`current_members` integer DEFAULT 0 NOT NULL,
	`status` text DEFAULT 'active' NOT NULL,
	`group_logs` text DEFAULT '{}' NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	`updated_at` integer DEFAULT 0,
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`campaign_id`) REFERENCES `webinar_campaigns`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`cohort_day_id`) REFERENCES `webinar_cohort_days`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `webinar_campaigns` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`name` text NOT NULL,
	`webinar_time` integer NOT NULL,
	`zalo_account_id` text NOT NULL,
	`zalo_group_id` text,
	`group_invite_link` text,
	`invite_message` text NOT NULL,
	`private_steps` text DEFAULT '[]' NOT NULL,
	`group_steps` text DEFAULT '[]' NOT NULL,
	`group_logs` text DEFAULT '{}' NOT NULL,
	`sessions` text DEFAULT '[]' NOT NULL,
	`status` text DEFAULT 'active' NOT NULL,
	`next_webinar_id` text,
	`send_welcome_message` integer DEFAULT true,
	`webinar_end_time` integer,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	`updated_at` integer DEFAULT 0,
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`zalo_account_id`) REFERENCES `zalo_accounts`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `webinar_cohort_days` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`campaign_id` text NOT NULL,
	`day_index` integer DEFAULT 1 NOT NULL,
	`offset_days` integer DEFAULT 0 NOT NULL,
	`time_of_day` text DEFAULT '20:00' NOT NULL,
	`scheduled_at` integer,
	`scheduled_end_time` integer,
	`name` text NOT NULL,
	`private_steps` text DEFAULT '[]' NOT NULL,
	`group_steps` text DEFAULT '[]' NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	`updated_at` integer DEFAULT 0,
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`campaign_id`) REFERENCES `webinar_campaigns`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `webinar_subscriber_events` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`campaign_id` text NOT NULL,
	`subscriber_id` text NOT NULL,
	`event_type` text NOT NULL,
	`watch_duration` integer DEFAULT 0,
	`watch_percentage` integer DEFAULT 0,
	`metadata` text DEFAULT '{}' NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`campaign_id`) REFERENCES `webinar_campaigns`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`subscriber_id`) REFERENCES `webinar_subscribers`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `webinar_subscribers` (
	`id` text PRIMARY KEY NOT NULL,
	`org_id` text NOT NULL,
	`campaign_id` text NOT NULL,
	`contact_id` text NOT NULL,
	`zalo_uid` text,
	`friend_request_sent` integer DEFAULT false,
	`joined_group` integer DEFAULT false,
	`assigned_group_id` text,
	`private_logs` text DEFAULT '{}' NOT NULL,
	`attended` integer DEFAULT false,
	`watch_duration` integer DEFAULT 0,
	`watch_percentage` integer DEFAULT 0,
	`cta_clicked` integer DEFAULT false,
	`cohort_logs` text DEFAULT '{}' NOT NULL,
	`engagement_data` text DEFAULT '{}' NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now') * 1000),
	FOREIGN KEY (`org_id`) REFERENCES `organizations`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`campaign_id`) REFERENCES `webinar_campaigns`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`contact_id`) REFERENCES `contacts`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`assigned_group_id`) REFERENCES `webinar_campaign_groups`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
ALTER TABLE `conversations` ADD `is_ignored` integer DEFAULT false NOT NULL;--> statement-breakpoint
CREATE INDEX `conversations_org_idx` ON `conversations` (`org_id`);--> statement-breakpoint
CREATE INDEX `conversations_last_msg_idx` ON `conversations` (`org_id`,`last_message_at`);--> statement-breakpoint
CREATE INDEX `conversations_contact_idx` ON `conversations` (`contact_id`);--> statement-breakpoint
ALTER TABLE `org_tags` ADD `group_id` text REFERENCES org_tag_groups(id);--> statement-breakpoint
ALTER TABLE `scheduled_messages` ADD `sequence_id` text;--> statement-breakpoint
ALTER TABLE `scheduled_messages` ADD `sequence_step_id` text;--> statement-breakpoint
ALTER TABLE `scheduled_messages` ADD `sequence_subscriber_id` text;--> statement-breakpoint
CREATE INDEX `contacts_org_id_idx` ON `contacts` (`org_id`);--> statement-breakpoint
CREATE INDEX `messages_conv_sent_idx` ON `messages` (`conversation_id`,`sent_at`);--> statement-breakpoint
CREATE INDEX `messages_sent_at_idx` ON `messages` (`sent_at`);--> statement-breakpoint
CREATE INDEX `messages_zalo_msg_idx` ON `messages` (`zalo_msg_id`);