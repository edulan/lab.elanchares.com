class ColorUtils
  @hexToRgb: (hex) ->
    throw new Error("Invalid hex string.") unless /#?([a-fA-F0-9]{6})/.test(hex)

    bigint = parseInt(hex, 16)
    r = (bigint >> 16) & 255
    g = (bigint >> 8) & 255
    b = bigint & 255

    [r, g, b]

class Chromosome
  CHARS: (d.toString(16) for d in [0..15])

  constructor: (@code = "", @cost = 9999) ->
    @mutationCount = 0

  getCode: ->
    @code

  getCost: ->
    @cost

  getMutationCount: ->
    @mutationCount

  calculateCost: (targetCode) ->
    sourceRgb = ColorUtils.hexToRgb(@code)
    targetRgb = ColorUtils.hexToRgb(targetCode)

    offsetRgb = [sourceRgb[0] - targetRgb[0], sourceRgb[1] - targetRgb[1], sourceRgb[2] - targetRgb[2]]

    totalCost = 0
    totalCost += componentCost for componentCost in (component * component for component in offsetRgb)

    @cost = totalCost

  randomize: (length) ->
    code = ''

    while length-- > 0
      charIndex = Math.floor(Math.random() * @CHARS.length)
      code += @CHARS[charIndex]

    @code = code

  mate: (chromosome) ->
    targetCode = chromosome.getCode()
    midIndex = Math.round(@code.length / 2) - 1
    combination1 = @code[0..midIndex] + targetCode[midIndex+1..-1]
    combination2 = targetCode[0..midIndex] + @code[midIndex+1..-1]

    [new Chromosome(combination1), new Chromosome(combination2)]

  mutate: ->
    randomIndex = Math.floor(Math.random() * @code.length)
    offset = if Math.random() <= 0.5 then -1 else 1

    randomChar = @code.charAt(randomIndex)
    charIndex = @CHARS.indexOf(randomChar)
    offsetIndex = Math.abs(charIndex + offset) % @CHARS.length
    offsetChar = @CHARS[offsetIndex]

    @code = @code[0...randomIndex] + offsetChar + @code[randomIndex+1..-1]
    @mutationCount++


class Population
  constructor: (@targetCode, @size, @factor, @mates) ->
    @members = []
    @generationCount = 0

    for i in [0...@size]
      chromosome = new Chromosome()
      chromosome.randomize(@targetCode.length)
      @members.push(chromosome)

  getGenerationCount: ->
    @generationCount

  getMembers: ->
    @members

  getBestMembers: ->
    @members[0..2]

  sort: ->
    @members.sort((member1, member2) ->
      member1.getCost() - member2.getCost()
    )

  getNextGeneration: ->
    member.calculateCost(@targetCode) for member in @members

    this.sort()

    args = [@members.length - @mates, @mates]

    mates = @mates / 2

    for i in [0..mates-1]
      children = @members[i].mate(@members[i+mates])
      args.push(children[0])
      args.push(children[1])

    @members.splice.apply(@members, args)

    for member in @members
      continue if Math.random() > @factor

      member.mutate()
      member.calculateCost(@targetCode)

      if member.getCode() == @targetCode
        return true

    @generationCount++
    return false

class Simulator
  constructor: (width, height) ->
    @layout = d3.layout.pack()
      .sort(null)
      .size([width, height])
      .padding(2)
    @vis = d3.select("#chart").append("svg")
      .attr("width", width)
      .attr("height", height)

  run: (targetCode, callback, populationSize = 20, mutationFactor = 0.5, mateFactor = 2) ->
    population = new Population(targetCode,
                                populationSize,
                                mutationFactor,
                                mateFactor)

    timeout = null
    tick = (result) =>
      return clearTimeout(timeout) if result

      result = population.getNextGeneration()
      this.displayPopulation(population)

      callback.call(this, population) if callback?

      timeout = setTimeout(->
        tick(result)
      , 0)
      result

    tick(false)

  displayPopulation: (population) ->
    data = (id: member.getCost(), color: member.getCode(), value: 16, alpha: 1.0 for member in population.getMembers())

    circles = @vis.selectAll("circle")
      .data(@layout.nodes({children: data}).filter((d) -> not d.children))
      .style("fill", (d) -> "##{d.color}")
      .attr("r", (d) -> d.r)
      .attr("opacity", (d) -> d.alpha)
      .attr("transform", (d) -> "translate(#{d.x},#{d.y})")
    titles = @vis.selectAll("title")
      .data(@layout.nodes({children: data}).filter((d) -> not d.children))
      .text((d) -> "##{d.color.toUpperCase()}" )
    circles.enter().append("circle")
      .style("fill", (d) -> "##{d.color}")
      .attr("r", (d) -> d.r)
      .attr("opacity", (d) -> d.alpha)
      .attr("transform", (d) -> "translate(#{d.x},#{d.y})")
      .append("title")
      .text((d) -> "##{d.color.toUpperCase()}" )
    circles.exit()
      .remove()

global = (exports ? window)
global.Chromosome = Chromosome
global.Population = Population
global.Simulator = Simulator
