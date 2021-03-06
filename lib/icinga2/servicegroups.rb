
# frozen_string_literal: true

module Icinga2

  # namespace for servicegroup handling
  module Servicegroups

    # add a servicegroup
    #
    # @param [Hash] params
    # @option params [String] :service_group servicegroup to create
    # @option params [String] :display_name the displayed name
    # @option params [String] :notes
    # @option params [String] :notes_url
    # @option params [String] :action_url
    #
    # @example
    #   @icinga.add_servicegroup(service_group: 'foo', display_name: 'FOO')
    #
    # @return [Hash] result
    #
    def add_servicegroup( params )

      raise ArgumentError.new(format('wrong type. \'params\' must be an Hash, given \'%s\'', params.class.to_s)) unless( params.is_a?(Hash) )
      raise ArgumentError.new('missing \'params\'') if( params.size.zero? )

      service_group = params.dig(:service_group)
      display_name  = params.dig(:display_name)
      notes         = params.dig(:notes)
      notes_url     = params.dig(:notes_url)
      action_url    = params.dig(:action_url)

      raise ArgumentError.new('Missing \'service_group\'') if( service_group.nil? )
      raise ArgumentError.new('Missing \'display_name\'') if( display_name.nil? )

      raise ArgumentError.new(format('wrong type. \'notes\' must be an Hash, given \'%s\'', notes.class.to_s)) unless( notes.is_a?(String) || notes.nil? )
      raise ArgumentError.new(format('wrong type. \'notes_url\' must be an Hash, given \'%s\'', notes_url.class.to_s)) unless( notes_url.is_a?(String) || notes_url.nil? )
      raise ArgumentError.new(format('wrong type. \'action_url\' must be an Hash, given \'%s\'', action_url.class.to_s)) unless( action_url.is_a?(String) || action_url.nil? )

      payload = {
        attrs: {
          display_name: display_name,
          notes: notes,
          notes_url: notes_url,
          action_url: action_url
        }
      }

      # remove all empty attrs
      payload.reject!{ |_k, v| v.nil? }
      payload[:attrs].reject!{ |_k, v| v.nil? }

      put(
        url: format( '%s/objects/servicegroups/%s', @icinga_api_url_base, service_group ),
        headers: @headers,
        options: @options,
        payload: payload
      )
    end

    # delete a servicegroup
    #
    # @param [Hash] params
    # @option params [String] :service_group servicegroup to delete
    #
    # @example
    #   @icinga.delete_servicegroup(service_group: 'foo')
    #
    # @return [Array] result
    #
    def delete_servicegroup( params )

      raise ArgumentError.new(format('wrong type. \'params\' must be an Hash, given \'%s\'', params.class.to_s)) unless( params.is_a?(Hash) )
      raise ArgumentError.new('missing \'params\'') if( params.size.zero? )

      service_group = params.dig(:service_group)

      raise ArgumentError.new('Missing \'service_group\'') if( service_group.nil? )

      delete(
        url: format( '%s/objects/servicegroups/%s?cascade=1', @icinga_api_url_base, service_group ),
        headers: @headers,
        options: @options
      )
    end

    # returns all servicegroups
    #
    # @param [Hash] params
    # @option params [String] :service_group ('') optional for a single servicegroup
    #
    # @example to get all users
    #    @icinga.servicegroups
    #
    # @example to get one user
    #    @icinga.servicegroups(service_group: 'disk')
    #
    # @return [Array] returns a hash with all servicegroups
    #
    def servicegroups( params = {} )

      service_group = params.dig(:service_group)

      url =
      if( service_group.nil? )
        format( '%s/objects/servicegroups'   , @icinga_api_url_base )
      else
        format( '%s/objects/servicegroups/%s', @icinga_api_url_base, service_group )
      end

      api_data(
        url: url,
        headers: @headers,
        options: @options
      )
    end

    # checks if the servicegroup exists
    #
    # @param [String] service_group the name of the servicegroup
    #
    # @example
    #    @icinga.exists_servicegroup?('disk')
    #
    # @return [Bool] returns true if the servicegroup exists
    #
    def exists_servicegroup?( service_group )

      raise ArgumentError.new(format('wrong type. \'service_group\' must be an String, given \'%s\'', service_group.class.to_s)) unless( service_group.is_a?(String) )
      raise ArgumentError.new('Missing \'service_group\'') if( service_group.size.zero? )

      result = servicegroups( service_group: service_group )
      result = JSON.parse( result ) if  result.is_a?( String )
      result = result.first if( result.is_a?(Array) )

      return false if( result.is_a?(Hash) && result.dig('code') == 404 )

      true
    end

  end
end
