
class ResourceBasicView extends FC.BasicView

	# we don't use the render-queue, but many other utils are useful
	@mixin ResourceViewMixin

	dayGridClass: ResourceDayGrid


	renderHead: ->
		super
		@dayGrid.processHeadResourceEls(@headContainerEl)


	triggerDateRender: ->
		if @isResourcesSet # wait for a requestDateRender that has resource data
			View::triggerDateRender.apply(this, arguments)


	forceEventsRender: (events) ->
		# don't impose any resource dependencies.
		# allow events to render even if resources haven't arrive yet.
		View::forceEventsRender.call(this, events)


	forceResourcesRender: (resources) ->
		@dayGrid.setResources(resources) # doesn't rerender

		if @isDateRendered
			@requestDateRender().then => # rerenders the whole grid, with resources
				@afterResourcesRender()
		else
			Promise.resolve()


	forceResourcesUnrender: (teardownOptions={}) ->
		@dayGrid.unsetResources() # doesn't rerender

		if @isDateRendered and not teardownOptions.skipRerender
			@requestDateRender().then => # rerenders the whole grid, with resources
				@afterResourcesUnrender()
		else
			Promise.resolve()
