create database if not exists ticket_db default character set utf8mb4 collate utf8mb4_unicode_ci;
use ticket_db;
create table users(
                      id BIGINT primary key auto_increment comment '用户主键ID',
                      username varchar(50) comment '账号' NOT NULL unique,
                      password_hash varchar(100) NOT NULL comment '密码',
                      identity varchar(20) comment '身份' default 'USER' NOT NULL
)comment '用户表';
create table tickets(
                        id BIGINT primary key auto_increment comment '工单主键ID',
                        ticket_num BIGINT unique comment '工单编号(对外)' NOT NULL,
                        title varchar(50) comment '工单标题' NOT NULL,
                        content text comment '工单内容' NOT NULL,
                        category varchar(20) comment '工单类型:设备故障/资源请求' NOT NULL,
                        status varchar(20) comment '状态:unresolved/assigend/resolved' default 'unresolved' NOT NULL,
                        creator_id BIGINT comment '创建工单者id' NOT NULL,
                        assigned_id BIGINT comment '指派处理者id',
                        created_time datetime comment '创建时间' default current_timestamp,
                        version int not null default 0 comment '乐观锁版本(防并发抢单)',
                        index idx_status_created (status,created_time),
                        index idx_creator (creator_id),
                        index idx_assignee (assigned_id)
)comment '工单表';
create table ticket_history(
                               id BIGINT primary key auto_increment comment '工单历史记录ID',
                               ticket_id BIGINT NOT NULL  comment '工单ID',
                               operator_id BIGINT NOT NULL comment '操作人ID',
                               from_status varchar(20) NULL comment '操作前状态',
                               after_status varchar(20) NOT NULL comment '操作后状态',
                               remark text NULL comment '操作备注',
                               created_time datetime comment '创建历史时间' default current_timestamp,
                               index idx_ticket_id (ticket_id)
)comment '工单操作历史记录表';