#pragma once
#include "entity.h"
class NonPlayerEntity :
	public Entity
	
{
private:
	unsigned char type_;
	unsigned char dataCount_;
	unsigned char *data_;
public:
	NonPlayerEntity(void);
	~NonPlayerEntity(void);
	unsigned char	type() const							{return type_;}
	void			type(unsigned char newType)				{type_ = newType;}
	unsigned char	dataCount() const						{return dataCount_;}
	void			dataCount(unsigned char newDataCount)	{dataCount_ = newDataCount;}
	unsigned char	data() const							{return dataCount_;}
	void			data(unsigned char *newData)			{data_ = newData;}
};

