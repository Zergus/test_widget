$.mockjax
  url: '/gen'
  responseTime: 1
  responseText:
    'itsafaaaaake'

$ ->
  $.widget "custom.generator",
    container: {}
    classNamespace: ''
    history: []

    _history: (self) ->
      $hist = self.container[self.options.history]
      
      update = ->
        $hist.html ''
        $hist.append "<li>#{data}</li>" for data in self.history
      
      return {
        push: (data)->
          self.history.push data
          update data
      }

    _create: ->
      do @_builder

    _builder: ->
      @classNamespace = @element.attr 'id'
      @_build("<input class='input'>")
      @_build("<button class='button'>#{@options.buttonText}</button>")
      @_build("<ul class='results'>")
      do @_construct

    _build: (el)->
      $el = $ el
      cl = $el.attr 'class'.toLowerCase()
      $el.data 'action', cl
      elClass = "#{@classNamespace}__#{cl}"
      $el.attr 'class', elClass
      @container[cl] = $el
      return @

    _construct: ->
      el.appendTo(@element) for name, el of @container
      do @_clicker
      do @_updater
      return @

    _updater: ->
      @element.on 'keyup', 'input', (e)=>
        @element.data 'origin', $(e.target).val()

    _clicker: ->
      @element.on 'click', (e)=>
        do @_sender if $(e.target).hasClass "#{@classNamespace}__#{@options.sender}"
        action = $(e.target).data 'action'
        @options[action]({value: @element.data 'origin'}) if @options[action]

    _sender: ->
      $.ajax
        type: "POST"
        url: "#{@options.url}"
        data: {origin: @element.data 'origin'}
        success: (r)=>
          @_history(@).push r

  $('#generator').generator 
    buttonText: 'GENERATE!'
    url: '/gen'
    sender: 'button'
    history: 'results'       
