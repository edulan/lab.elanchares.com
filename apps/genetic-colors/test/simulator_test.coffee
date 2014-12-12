assert = require("assert")
simulator  = require("./simulator")

describe("Chromosome", ->
	describe("#getCode()", ->
		it("should return the chromosome code", ->
			chromosome = new simulator.Chromosome("FFFFFF")

			assert.equal "FFFFFF", chromosome.getCode()
		)

		describe("with no code given", ->
			it("should return an empty code", ->
				chromosome = new simulator.Chromosome()

				assert.equal "", chromosome.getCode()
			)
		)
	)

	describe("#getCost()", ->
		it("should return the chromosome cost", ->
			chromosome = new simulator.Chromosome("", 0)

			assert.equal 0, chromosome.getCost()
		)

		describe("with no cost given", ->
			it("should return default cost", ->
				chromosome = new simulator.Chromosome()

				assert.equal 9999, chromosome.getCost()
			)
		)
	)

	describe("#calculateCost()", ->
		it("should calculate the chromosome cost from a given code", ->
			chromosome = new simulator.Chromosome("FFFFFF")

			assert.equal 2904, chromosome.calculateCost("000000")
		)

		it("should throw an error when codes length does not match")
	)

	describe("#randomize()", ->
		it("should randomize the chromosome code", ->
			chromosome = new simulator.Chromosome("FFFFFF")

			previousCode = chromosome.getCode()
			chromosome.randomize(6)
			randomCode = chromosome.getCode()
			assert.notEqual previousCode, randomCode
		)
	)

	describe("#mate()", ->
		describe("with even code length", ->
			it("should merge the chromosome with given chromosome", ->
				chromosome1 = new simulator.Chromosome("000FFF")
				chromosome2 = new simulator.Chromosome("FFF000")

				chromosomes = chromosome1.mate(chromosome2)
				assert.equal "000000", chromosomes[0].getCode()
				assert.equal "FFFFFF", chromosomes[1].getCode()
			)

			it("should have the same code length", ->
				chromosome1 = new simulator.Chromosome("000FFF")
				chromosome2 = new simulator.Chromosome("FFF000")

				chromosomes = chromosome1.mate(chromosome2)
				assert.equal "000FFF".length, chromosomes[0].getCode().length
				assert.equal "FFF000".length, chromosomes[1].getCode().length
			)
		)

		describe("with odd code length", ->
			it("should merge the chromosome with given chromosome", ->
				chromosome1 = new simulator.Chromosome("000FFFA")
				chromosome2 = new simulator.Chromosome("A000FFF")

				chromosomes = chromosome1.mate(chromosome2)
				assert.equal "000FFFF", chromosomes[0].getCode()
				assert.equal "A000FFA", chromosomes[1].getCode()
			)

			it("should have the same code length", ->
				chromosome1 = new simulator.Chromosome("000FFFA")
				chromosome2 = new simulator.Chromosome("A000FFF")

				chromosomes = chromosome1.mate(chromosome2)
				assert.equal "000FFFA".length, chromosomes[0].getCode().length
				assert.equal "A000FFF".length, chromosomes[1].getCode().length
			)
		)
	)

	describe("#mutate()", ->
		describe("with even code length", ->
			it("should alter the chromosome code", ->
				chromosome = new simulator.Chromosome("000FFF")

				chromosome.mutate()
				assert.notEqual "000FFF", chromosome.getCode()
			)

			it("should preserve code length", ->
				chromosome = new simulator.Chromosome("000FFF")

				chromosome.mutate()
				assert.equal "000FFF".length, chromosome.getCode().length
			)
		)

		describe("with odd code length", ->
			it("should alter the chromosome code", ->
				chromosome = new simulator.Chromosome("000FFFA")

				chromosome.mutate()
				assert.notEqual "000FFFA", chromosome.getCode()
			)

			it("should preserve code length", ->
				chromosome = new simulator.Chromosome("000FFFA")

				chromosome.mutate()
				assert.equal "000FFFA".length, chromosome.getCode().length
			)
		)
	)
)

describe("Population", ->
	describe("#getGenerationCount()", ->
		it("should return the population generation count", ->
			population = new simulator.Population("FFFFFF")

			assert.equal 0, population.getGenerationCount()
		)
	)

	describe("#getBestMembers()", ->
		it("should return the population best members", ->
			population = new simulator.Population("FFFFFF", 10)

			assert.equal 3, population.getBestMembers().length
		)
	)

	describe("#sort()", ->
		it("should sort population members by cost in ascending order")
	)

	describe("#getNextGeneration()", ->
		it("should preserve population member size", ->
			population = new simulator.Population("FFFFFF", 10)

			population.getNextGeneration()
			assert.equal 10, population.getMembers().length
		)

		describe("when no solution was found", ->
			it("should return false", ->
				population = new simulator.Population("FFFFFF", 10)

				assert.equal false, population.getNextGeneration()
			)
		)
	)
)
