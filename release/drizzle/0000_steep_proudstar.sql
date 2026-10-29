CREATE TABLE "activity_logs" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"user_id" text,
	"action" text NOT NULL,
	"entity_type" text,
	"entity_id" text,
	"details" jsonb DEFAULT '{}'::jsonb,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "app_settings" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"setting_key" text NOT NULL,
	"value_plain" text,
	"value_encrypted" text,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "org_tags" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"name" text NOT NULL,
	"color" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "organizations" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "push_subscriptions" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"subscription" text NOT NULL,
	"device_type" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "scheduled_messages" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"zalo_account_id" text NOT NULL,
	"recipient_zalo_uid" text NOT NULL,
	"recipient_name" text,
	"type" text DEFAULT 'text' NOT NULL,
	"content" text,
	"attachments" jsonb DEFAULT '[]'::jsonb,
	"ref_type" text,
	"ref_id" text,
	"scheduled_at" timestamp with time zone NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"sent_at" timestamp with time zone,
	"error_message" text,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "teams" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"name" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"team_id" text,
	"email" text NOT NULL,
	"password_hash" text NOT NULL,
	"full_name" text NOT NULL,
	"role" text DEFAULT 'member' NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now(),
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "video_script_chats" (
	"id" text PRIMARY KEY NOT NULL,
	"script_id" text NOT NULL,
	"at_second" integer DEFAULT 0 NOT NULL,
	"sender_name" text NOT NULL,
	"avatar_url" text,
	"message" text NOT NULL,
	"is_qna" boolean DEFAULT false NOT NULL,
	"attachments" jsonb DEFAULT '[]'::jsonb,
	"parent_id" text,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "video_script_ctas" (
	"id" text PRIMARY KEY NOT NULL,
	"script_id" text NOT NULL,
	"at_second" integer DEFAULT 0 NOT NULL,
	"headline" text NOT NULL,
	"description" text,
	"button_text" text DEFAULT 'ĐĂNG KÝ NGAY' NOT NULL,
	"button_color" text DEFAULT '#e11d48',
	"link" text NOT NULL,
	"html" text,
	"image_url" text,
	"countdown_minutes" integer DEFAULT 0,
	"display_duration_seconds" integer DEFAULT 300 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "video_scripts" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"video_type" text DEFAULT 'youtube' NOT NULL,
	"video_url" text NOT NULL,
	"duration_seconds" integer DEFAULT 3600 NOT NULL,
	"initial_fake_attendees" integer DEFAULT 15 NOT NULL,
	"peak_fake_attendees" integer DEFAULT 250 NOT NULL,
	"fake_attendees_config" jsonb DEFAULT '[]'::jsonb,
	"seeding_interval_seconds" integer DEFAULT 5 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "watch_events" (
	"id" text PRIMARY KEY NOT NULL,
	"attendee_id" text NOT NULL,
	"session_id" text,
	"event_type" text NOT NULL,
	"watch_percent" double precision DEFAULT 0,
	"video_position_seconds" integer DEFAULT 0,
	"timestamp" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "webinar_attendances" (
	"id" text PRIMARY KEY NOT NULL,
	"attendee_id" text NOT NULL,
	"session_id" text NOT NULL,
	"joined_at" timestamp with time zone,
	"left_at" timestamp with time zone,
	"watch_percent" double precision DEFAULT 0,
	"watch_duration_seconds" integer DEFAULT 0,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "webinar_attendee_history" (
	"id" text PRIMARY KEY NOT NULL,
	"attendee_id" text NOT NULL,
	"webinar_id" text NOT NULL,
	"session_id" text,
	"old_name" text,
	"new_name" text NOT NULL,
	"email" text,
	"status" text DEFAULT 'registered' NOT NULL,
	"watch_duration_seconds" integer DEFAULT 0 NOT NULL,
	"watch_percent" double precision DEFAULT 0,
	"tags" jsonb DEFAULT '[]'::jsonb,
	"utm_source" text,
	"metadata" jsonb DEFAULT '{}'::jsonb,
	"registered_at" timestamp with time zone DEFAULT now(),
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "webinar_attendees" (
	"id" text PRIMARY KEY NOT NULL,
	"webinar_id" text NOT NULL,
	"org_id" text NOT NULL,
	"full_name" text NOT NULL,
	"phone" text,
	"email" text,
	"zalo_uid" text,
	"zalo_account_id" text,
	"session_id" text,
	"status" text DEFAULT 'registered' NOT NULL,
	"last_reminder_sent_at" timestamp with time zone,
	"reminder_count" integer DEFAULT 0 NOT NULL,
	"replay_link_sent_at" timestamp with time zone,
	"upsell_sent_at" timestamp with time zone,
	"upsell_status" text,
	"source" text DEFAULT 'landing_page',
	"utm_source" text,
	"metadata" jsonb DEFAULT '{}'::jsonb,
	"registered_at" timestamp with time zone DEFAULT now(),
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "webinar_chats" (
	"id" text PRIMARY KEY NOT NULL,
	"webinar_id" text NOT NULL,
	"session_id" text,
	"attendee_id" text,
	"sender_name" text NOT NULL,
	"message" text NOT NULL,
	"is_qna" boolean DEFAULT false NOT NULL,
	"is_approved" boolean DEFAULT true NOT NULL,
	"at_second" integer DEFAULT 0 NOT NULL,
	"is_seeding" boolean DEFAULT false NOT NULL,
	"attachments" jsonb DEFAULT '[]'::jsonb,
	"parent_id" text,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "webinar_reminders" (
	"id" text PRIMARY KEY NOT NULL,
	"webinar_id" text NOT NULL,
	"trigger_type" text NOT NULL,
	"offset_minutes" integer DEFAULT 0 NOT NULL,
	"message_template" text NOT NULL,
	"attachments" jsonb DEFAULT '[]'::jsonb,
	"enabled" boolean DEFAULT true NOT NULL,
	"order" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "webinar_sessions" (
	"id" text PRIMARY KEY NOT NULL,
	"webinar_id" text NOT NULL,
	"scheduled_at" timestamp with time zone NOT NULL,
	"status" text DEFAULT 'upcoming' NOT NULL,
	"attendee_count" integer DEFAULT 0 NOT NULL,
	"show_up_count" integer DEFAULT 0 NOT NULL,
	"watched_count" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "webinars" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"created_by_user_id" text,
	"title" text NOT NULL,
	"description" text,
	"slug" text NOT NULL,
	"thumbnail_url" text,
	"host_name" text,
	"host_avatar_url" text,
	"video_type" text DEFAULT 'youtube' NOT NULL,
	"video_url" text NOT NULL,
	"duration_minutes" integer DEFAULT 60 NOT NULL,
	"schedule_type" text DEFAULT 'recurring' NOT NULL,
	"start_time" timestamp with time zone,
	"just_in_time_minutes" integer DEFAULT 15,
	"run_days" jsonb DEFAULT '[]'::jsonb,
	"run_times" jsonb DEFAULT '[]'::jsonb,
	"timezone" text DEFAULT 'Asia/Ho_Chi_Minh' NOT NULL,
	"cta_config" jsonb DEFAULT '{"enabled":false,"text":"Mua ngay khóa học","link":"","showAtSecond":0,"buttonColor":"#4f46e5"}'::jsonb,
	"landing_config" jsonb DEFAULT '{"headline":"","subheadline":"","ctaText":"Đăng ký miễn phí","benefits":[],"socialProof":true}'::jsonb,
	"zalo_account_id" text,
	"script_id" text,
	"status" text DEFAULT 'draft' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "zalo_account_access" (
	"id" text PRIMARY KEY NOT NULL,
	"zalo_account_id" text NOT NULL,
	"user_id" text NOT NULL,
	"permission" text DEFAULT 'read' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "zalo_accounts" (
	"id" text PRIMARY KEY NOT NULL,
	"org_id" text NOT NULL,
	"owner_user_id" text NOT NULL,
	"zalo_uid" text,
	"display_name" text,
	"avatar_url" text,
	"phone" text,
	"status" text DEFAULT 'disconnected' NOT NULL,
	"session_data" jsonb,
	"last_connected_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now(),
	CONSTRAINT "zalo_accounts_zalo_uid_unique" UNIQUE("zalo_uid")
);
--> statement-breakpoint
ALTER TABLE "activity_logs" ADD CONSTRAINT "activity_logs_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "activity_logs" ADD CONSTRAINT "activity_logs_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "org_tags" ADD CONSTRAINT "org_tags_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "push_subscriptions" ADD CONSTRAINT "push_subscriptions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "scheduled_messages" ADD CONSTRAINT "scheduled_messages_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "scheduled_messages" ADD CONSTRAINT "scheduled_messages_zalo_account_id_zalo_accounts_id_fk" FOREIGN KEY ("zalo_account_id") REFERENCES "public"."zalo_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "teams" ADD CONSTRAINT "teams_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_team_id_teams_id_fk" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "video_script_chats" ADD CONSTRAINT "video_script_chats_script_id_video_scripts_id_fk" FOREIGN KEY ("script_id") REFERENCES "public"."video_scripts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "video_script_ctas" ADD CONSTRAINT "video_script_ctas_script_id_video_scripts_id_fk" FOREIGN KEY ("script_id") REFERENCES "public"."video_scripts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "video_scripts" ADD CONSTRAINT "video_scripts_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "watch_events" ADD CONSTRAINT "watch_events_attendee_id_webinar_attendees_id_fk" FOREIGN KEY ("attendee_id") REFERENCES "public"."webinar_attendees"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_attendances" ADD CONSTRAINT "webinar_attendances_attendee_id_webinar_attendees_id_fk" FOREIGN KEY ("attendee_id") REFERENCES "public"."webinar_attendees"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_attendee_history" ADD CONSTRAINT "webinar_attendee_history_attendee_id_webinar_attendees_id_fk" FOREIGN KEY ("attendee_id") REFERENCES "public"."webinar_attendees"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_attendee_history" ADD CONSTRAINT "webinar_attendee_history_webinar_id_webinars_id_fk" FOREIGN KEY ("webinar_id") REFERENCES "public"."webinars"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_attendees" ADD CONSTRAINT "webinar_attendees_webinar_id_webinars_id_fk" FOREIGN KEY ("webinar_id") REFERENCES "public"."webinars"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_attendees" ADD CONSTRAINT "webinar_attendees_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_attendees" ADD CONSTRAINT "webinar_attendees_zalo_account_id_zalo_accounts_id_fk" FOREIGN KEY ("zalo_account_id") REFERENCES "public"."zalo_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_chats" ADD CONSTRAINT "webinar_chats_webinar_id_webinars_id_fk" FOREIGN KEY ("webinar_id") REFERENCES "public"."webinars"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_reminders" ADD CONSTRAINT "webinar_reminders_webinar_id_webinars_id_fk" FOREIGN KEY ("webinar_id") REFERENCES "public"."webinars"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinar_sessions" ADD CONSTRAINT "webinar_sessions_webinar_id_webinars_id_fk" FOREIGN KEY ("webinar_id") REFERENCES "public"."webinars"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinars" ADD CONSTRAINT "webinars_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinars" ADD CONSTRAINT "webinars_created_by_user_id_users_id_fk" FOREIGN KEY ("created_by_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "webinars" ADD CONSTRAINT "webinars_zalo_account_id_zalo_accounts_id_fk" FOREIGN KEY ("zalo_account_id") REFERENCES "public"."zalo_accounts"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "zalo_account_access" ADD CONSTRAINT "zalo_account_access_zalo_account_id_zalo_accounts_id_fk" FOREIGN KEY ("zalo_account_id") REFERENCES "public"."zalo_accounts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "zalo_account_access" ADD CONSTRAINT "zalo_account_access_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "zalo_accounts" ADD CONSTRAINT "zalo_accounts_org_id_organizations_id_fk" FOREIGN KEY ("org_id") REFERENCES "public"."organizations"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "zalo_accounts" ADD CONSTRAINT "zalo_accounts_owner_user_id_users_id_fk" FOREIGN KEY ("owner_user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "app_settings_unq" ON "app_settings" USING btree ("org_id","setting_key");--> statement-breakpoint
CREATE INDEX "scheduled_messages_status_idx" ON "scheduled_messages" USING btree ("org_id","status","scheduled_at");--> statement-breakpoint
CREATE INDEX "video_script_chats_time_idx" ON "video_script_chats" USING btree ("script_id","at_second");--> statement-breakpoint
CREATE INDEX "video_script_ctas_time_idx" ON "video_script_ctas" USING btree ("script_id","at_second");--> statement-breakpoint
CREATE INDEX "watch_events_attendee_idx" ON "watch_events" USING btree ("attendee_id","timestamp");--> statement-breakpoint
CREATE UNIQUE INDEX "webinar_attendances_unq" ON "webinar_attendances" USING btree ("attendee_id","session_id");--> statement-breakpoint
CREATE INDEX "webinar_attendee_history_attendee_idx" ON "webinar_attendee_history" USING btree ("attendee_id");--> statement-breakpoint
CREATE INDEX "webinar_attendee_history_webinar_idx" ON "webinar_attendee_history" USING btree ("webinar_id");--> statement-breakpoint
CREATE INDEX "webinar_attendees_webinar_idx" ON "webinar_attendees" USING btree ("webinar_id","registered_at");--> statement-breakpoint
CREATE INDEX "webinar_attendees_phone_idx" ON "webinar_attendees" USING btree ("webinar_id","phone");--> statement-breakpoint
CREATE INDEX "webinar_attendees_zalo_idx" ON "webinar_attendees" USING btree ("webinar_id","zalo_uid");--> statement-breakpoint
CREATE INDEX "webinar_chats_webinar_idx" ON "webinar_chats" USING btree ("webinar_id","session_id","created_at");--> statement-breakpoint
CREATE INDEX "webinar_reminders_webinar_idx" ON "webinar_reminders" USING btree ("webinar_id","enabled");--> statement-breakpoint
CREATE INDEX "webinar_sessions_webinar_idx" ON "webinar_sessions" USING btree ("webinar_id","scheduled_at");--> statement-breakpoint
CREATE INDEX "webinar_sessions_status_idx" ON "webinar_sessions" USING btree ("status","scheduled_at");--> statement-breakpoint
CREATE UNIQUE INDEX "webinars_slug_unq" ON "webinars" USING btree ("slug");--> statement-breakpoint
CREATE INDEX "webinars_org_idx" ON "webinars" USING btree ("org_id","status");--> statement-breakpoint
CREATE UNIQUE INDEX "zalo_account_access_unq" ON "zalo_account_access" USING btree ("zalo_account_id","user_id");