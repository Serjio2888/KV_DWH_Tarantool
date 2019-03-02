#!/usr/bin/env tarantool

box.cfg{}
log=require('log')

box.once('schema', function()
	box.schema.create_space('hosts')
	box.space.hosts:create_index('primary', { type = 'hash',
    	parts = {1, 'str'} })
end)


box.cfg{log_format='plain'}
log.info('Tarantool start')

local function hand(self)
	q = self.query
	if box.space.hosts:select{q}[1] then
		log.info('get '..q)
			return self:render{json=box.space.hosts:select{q}[1][2]} 
	else
		log.error('404 in get')
			return {status = 404} 
	end
end

local function del(self)
	q = self.query
	if box.space.hosts:select{q}[1] then
		log.info('deleted '..q)
			return self:render{json=box.space.hosts:delete{q}} 
	else
		log.error('404 in delete')
			return {status = 404} 
	end
end

function names(table)
	if table['key'] then
	    if table['value'] then
			return table['key'], table['value']    
		end
	else 
		return (nil),(nil) 
	end
end

local function post(self)
	key, value = names(self:post_param())
	if key == nil then
		log.error('400 in post')
			return {status = 400} 
	end
	if box.space.hosts:select{key}[1] then
		log.error('409 in post')
			return {status = 409}	
	end
	box.space.hosts:insert({key, value})
	log.info('post '..key..' '..value)
	resp = self:render{json = self:post_param()['value']}
	resp.status = 200
		return resp 
end

local function put(self)
	key, value = names(self:param())
	if key == nil then
		log.error('400 in put')
			return {status = 400} 
	end
	if box.space.hosts:select{key}[1] then
		log.info('put '..key..' '..value)
		box.space.hosts:upsert({key}, {{'=', 2, value}})
			return { status = 200}
	else
		log.error('404 in put')
			return {status = 404} 
	end
end
	

local httpd = require('http.server')
local server = httpd.new('127.0.0.1', 8003)
server:route({ path = '/', method = 'GET'   },   hand)
server:route({ path = '/', method = 'POST'  },   post)
server:route({ path = '/', method = 'DELETE'},    del)
server:route({ path = '/', method = 'PUT'   },    put)
server:start()

