class RolifyCreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table(:roles) do |t|
      t.string :name, limit: 32
      t.references :resource, :polymorphic => true
      #t.integer :resource_id
      #t.string :resource_type, limit: 191

      t.timestamps
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end
    
    add_index(:roles, :name)
    #add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:roles, [ :name, :resource_id ])
    add_index(:users_roles, [ :user_id, :role_id ])
  end
end

# CREATE TABLE `roles` (
# 	`id` BIGINT(20) NOT NULL AUTO_INCREMENT,
# 	`name` VARCHAR(32) NULL DEFAULT NULL,
# 	`resource_type` VARCHAR(191) NULL DEFAULT NULL,
# 	`resource_id` BIGINT(20) NULL DEFAULT NULL,
# 	`created_at` DATETIME NOT NULL,
# 	`updated_at` DATETIME NOT NULL,
# 	PRIMARY KEY (`id`),
# 	INDEX `index_roles_on_resource_type_and_resource_id` (`resource_type`, `resource_id`),
# 	INDEX `index_roles_on_name` (`name`),
# 	INDEX `index_roles_on_name_and_resource_type_and_resource_id` (`name`, `resource_type`, `resource_id`)
# )
# COLLATE='utf8mb4_general_ci'
# ENGINE=InnoDB
# AUTO_INCREMENT=23
# ;