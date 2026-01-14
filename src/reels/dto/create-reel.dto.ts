import { Type } from 'class-transformer';
import {
  IsNotEmpty,
  MinLength,
  MaxLength,
  IsMongoId,
  IsUrl,
  IsString,
  IsOptional,
} from 'class-validator';
import { Types } from 'mongoose';

export class CreateReelDto {
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  @MaxLength(100)
  title: string;

  @IsNotEmpty()
  videoFile: Express.Multer.File;

  @IsNotEmpty()
  thumbnailFile: Express.Multer.File;

  @IsNotEmpty()
  @IsMongoId()
  @Type(() => Types.ObjectId)
  projectId: Types.ObjectId;

  @IsNotEmpty()
  @IsMongoId()
  @Type(() => Types.ObjectId)
  developerId: Types.ObjectId;
}
