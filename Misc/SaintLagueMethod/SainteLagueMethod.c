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

#include "SainteLagueMethod.h"
#include <assert.h>


enum SLEvent
{
	kSLPartyExcludedBelowThreshold,
	kSLPartyIncludedInApportionment,
	kSLPartySeatAssigned,
	kSLPartyFinalSeats
};


typedef struct SLCalcInfo
{
	const void			*tag;			// For client to identify parties.
	uintmax_t			votes;			// Absolute number of votes cast.
	uintmax_t			divisor;		// Divisor, multiplied by ten to allow integer maths. Starts at 14.
	uintmax_t			nextDivisor;	// Next divisor to use (after a seat has been assigned), multiplied by ten. Starts at 30, increases by 20 per seat.
	uintmax_t			seats;			// Seats assigned.
} SLCalcInfo;


static int CompareSLCalcInfo(const void *a, const void *b)
{
	const SLCalcInfo *infoA = a;
	const SLCalcInfo *infoB = b;
	
	/*	Calculate comparators. Note that comparing A.votes * B.divisor with
		B.votes * A.divisor is algebraically equivalent to comparing
		A.votes / A.divisor with B.votes / B.divisor, but allows us to stick
		with integer maths.
		
		Also note that this is reverse sort order (biggest result first).
	*/
	uintmax_t			compA = infoA->votes * infoB->divisor;
	uintmax_t			compB = infoB->votes * infoA->divisor;
	
	// Check for overflow.
	assert(compA / infoB->divisor == infoA->votes);
	assert(compB / infoA->divisor == infoB->votes);
	
	if (compA < compB)  return 1;
	if (compA > compB)  return -1;
	return 0;
}


void SLCalculate(SLParty *parties, size_t count, uintmax_t seats, uintmax_t thresholdNumerator, uintmax_t thresholdDenominator)
{
	uintmax_t			i, totalVotes = 0;
	SLParty				excludedParties[count];
	SLCalcInfo			calcParties[count];
	size_t				excludedCount = 0, calcCount = 0;
	
	assert(parties != NULL);
	assert(thresholdDenominator != 0);
	
	// Count total votes.
	for (i = 0; i < count; i++)
	{
		totalVotes += parties[i].votes;
	}
	
	// Divide parties into excluded (below threshold) and calc.
	for (i = 0; i < count; i++)
	{
		if (parties[i].votes * thresholdDenominator < totalVotes * thresholdNumerator)
		{
			excludedParties[excludedCount++] = parties[i];
			PrintSLInfo(parties[i].tag, kSLPartyExcludedBelowThreshold, parties[i].votes, totalVotes, 0, 0.0);
		}
		else
		{
			calcParties[calcCount].tag = parties[i].tag;
			calcParties[calcCount].votes = parties[i].votes;
			calcParties[calcCount].divisor = 14;
			calcParties[calcCount].nextDivisor = 30;
			calcParties[calcCount].seats = 0;
			PrintSLInfo(parties[calcCount].tag, kSLPartyIncludedInApportionment, parties[calcCount].votes, totalVotes, 0, 0.0);
			calcCount++;
		}
	}
	
	// Assign seats.
	if (calcCount > 0)
	{
		for (i = 0; i < seats; i++)
		{
			qsort(calcParties, calcCount, sizeof *calcParties, CompareSLCalcInfo);
			
			// Zeroth party in list is next assignee
			calcParties[0].seats++;
			PrintSLInfo(calcParties[0].tag, kSLPartySeatAssigned, calcParties[0].votes, totalVotes, calcParties[0].seats, (double)calcParties[0].votes * 10.0 / (double)calcParties[0].divisor);
			
			calcParties[0].divisor = calcParties[0].nextDivisor;
			calcParties[0].nextDivisor += 20;
		}
	}
	
	// Merge calcParties and excludedParties into result.
	for (i = 0; i < calcCount; i++)
	{
		parties[i].tag = calcParties[i].tag;
		parties[i].votes = calcParties[i].votes;
		parties[i].seats = calcParties[i].seats;
		
		PrintSLInfo(parties[i].tag, kSLPartyFinalSeats, parties[i].votes, totalVotes, parties[i].seats, 0.0);
	}
	for (i = 0; i < excludedCount; i++)
	{
		parties[i + calcCount].tag = excludedParties[i].tag;
		parties[i + calcCount].votes = excludedParties[i].votes;
		parties[i + calcCount].seats = 0;
		
		PrintSLInfo(parties[i + calcCount].tag, kSLPartyFinalSeats, parties[i + calcCount].votes, totalVotes, 0, 0.0);
	}
}
