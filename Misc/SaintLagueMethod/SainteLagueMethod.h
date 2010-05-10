/*
	SainteLagueMethod.h
	Jens Ayton, 2009
	
	Calculate vote apportionment with the modified Sainte-Laguë method
	(using an initial divisor of 1.4) and a threshold, as used in (among
	others) Swedish elections. See
	http://en.wikipedia.org/wiki/Sainte-Lagu%C3%AB_method or
	http://www.val.se/det_svenska_valsystemet/valresultat/rakneexempel/index.html
	for more information, or the Swedish election law (SFS 2005:837) chapter
	14 section 3 for the normative (for Sweden) definition.
	
	This implementation uses some simple algebraic transformations of the
	"pure" algorithm to allow it to work entirely with integer mathematics.
	
	This code is hereby released under the CC0 license:
	
	The person who associated a work with this document has dedicated this
	work to the Commons by waiving all of his or her rights to the work under
	copyright law and all related or neighboring legal rights he or she had in
	the work, to the extent allowable by law.
	
		Other Rights — In no way are any of the following rights affected by
		CC0:
			* Patent or trademark rights held by the person who associated
			  this document with a work.
			* Rights other persons may have either in the work itself or in
			  how the work is used, such as publicity or privacy rights.
	
	http://wiki.creativecommons.org/CC0
*/

#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>


typedef struct SLParty
{
	const void			*tag;	// For client to identify parties
	uintmax_t			votes;	// Input
	uintmax_t			seats;	// Output
} SLParty;


/*	Calculate election result using Swedish counting method, “jämkade
	uddatalsmetoden”. On input, parties is an array of SLParty with tag and
	votes set. On return, it contains the same parties in arbitrary order with
	seats filled in; the client code should use the tag fields to identify
	parties.
*/
void SLCalculate(SLParty *parties, size_t count, uintmax_t seats, uintmax_t thresholdNumerator, uintmax_t thresholdDenominator);


/*	Optional client-defined logging function.
*/
#ifndef SL_LOGGING
#define SL_LOGGING 0
#endif

#if SL_LOGGING
// Client-defined.
extern void PrintSLInfo(const void *tag, unsigned event, uintmax_t votes, uintmax_t totalVotes, uintmax_t seats, double comparator);
#else
#define PrintSLInfo(tag, event, votes, totalVotes, seats, comparator) do {} while (0)
#endif
