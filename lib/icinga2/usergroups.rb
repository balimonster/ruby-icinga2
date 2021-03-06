
# frozen_string_literal: true

module Icinga2

  # namespace for usergroup handling
  module Usergroups

    # add a usergroup
    #
    # @param [Hash] params
    # @option params [String] :user_group usergroup to create
    # @option params [String] :display_name the displayed name
    #
    # @example
    #   @icinga.add_usergroup(user_group: 'foo', display_name: 'FOO')
    #
    # @return [Hash] result
    #
    def add_usergroup( params )

      raise ArgumentError.new(format('wrong type. \'params\' must be an Hash, given \'%s\'', params.class.to_s)) unless( params.is_a?(Hash) )
      raise ArgumentError.new('missing \'params\'') if( params.size.zero? )

      user_group   = params.dig(:user_group)
      display_name = params.dig(:display_name)

      raise ArgumentError.new('Missing user_group') if( user_group.nil? )

      payload = {
        attrs: {
          display_name: display_name
        }
      }

      put(
        url: format( '%s/objects/usergroups/%s', @icinga_api_url_base, user_group ),
        headers: @headers,
        options: @options,
        payload: payload
      )
    end

    # delete a usergroup
    #
    # @param [Hash] params
    # @option params [String] :user_group usergroup to delete
    #
    # @example
    #   @icinga.delete_usergroup(user_group: 'foo')
    #
    # @return [Hash] result
    #
    def delete_usergroup( params )

      raise ArgumentError.new(format('wrong type. \'params\' must be an Hash, given \'%s\'', params.class.to_s)) unless( params.is_a?(Hash) )
      raise ArgumentError.new('missing \'params\'') if( params.size.zero? )

      user_group = params.dig(:user_group)

      raise ArgumentError.new('Missing user_group') if( user_group.nil? )

      delete(
        url: format( '%s/objects/usergroups/%s?cascade=1', @icinga_api_url_base, user_group ),
        headers: @headers,
        options: @options
      )
    end

    # returns all usersgroups
    #
    # @param [Hash] params
    # @option params [String] :user_group ('') optional for a single usergroup
    #
    # @example to get all users
    #    @icinga.usergroups
    #
    # @example to get one user
    #    @icinga.usergroups(user_group: 'icingaadmins')
    #
    # @return [Hash] returns a hash with all usergroups
    #
    def usergroups( params = {} )

      user_group = params.dig(:user_group)

      url =
      if( user_group.nil? )
        format( '%s/objects/usergroups'   , @icinga_api_url_base )
      else
        format( '%s/objects/usergroups/%s', @icinga_api_url_base, user_group )
      end

      api_data(
        url: url,
        headers: @headers,
        options: @options
      )
    end

    # returns true if the usergroup exists
    #
    # @param [String] user_group the name of the usergroups
    #
    # @example
    #    @icinga.exists_usergroup?('icingaadmins')
    #
    # @return [Bool] returns true if the usergroup exists
    #
    def exists_usergroup?( user_group )

      raise ArgumentError.new(format('wrong type. \'user_group\' must be an String, given \'%s\'', user_group.class.to_s)) unless( user_group.is_a?(String) )
      raise ArgumentError.new('Missing \'user_group\'') if( user_group.size.zero? )

      result = usergroups( user_group: user_group )
      result = JSON.parse( result ) if  result.is_a?( String )
      result = result.first if( result.is_a?(Array) )

      return false if( result.is_a?(Hash) && result.dig('code') == 404 )

      true
    end

  end
end
