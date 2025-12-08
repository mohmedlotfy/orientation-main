import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { Model, Types } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private userModel: Model<UserDocument>) {}

  async create(createUserDto: CreateUserDto) {
    const user = new this.userModel({
      ...createUserDto,
      password: await bcrypt.hash(createUserDto.password, 10),
    });
    return await user
      .save()
      .then((user) => {
        return {
          message: 'User created successfully',
          user,
        };
      })
      .catch((error) => {
        throw new BadRequestException(error.message);
      });
  }

  async findAll() {
    return await this.userModel
      .find()
      .then((users) => {
        return {
          message: 'Users fetched successfully',
          users,
        };
      })
      .catch((error) => {
        throw new BadRequestException(error.message);
      });
  }

  async findOne(id: Types.ObjectId) {
    return await this.userModel
      .findById(id)
      .then((user) => {
        return {
          message: 'User fetched successfully',
          user,
        };
      })
      .catch((error) => {
        throw new BadRequestException(error.message);
      });
  }

  async update(id: Types.ObjectId, updateUserDto: UpdateUserDto) {
    return await this.userModel
      .findByIdAndUpdate(id, updateUserDto, { new: true })
      .then((user) => {
        return {
          message: 'User updated successfully',
          user,
        };
      })
      .catch((error) => {
        throw new BadRequestException(error.message);
      });
  }

  async remove(id: Types.ObjectId) {
    return await this.userModel
      .findByIdAndDelete(id)
      .then((user) => {
        return {
          message: 'User deleted successfully',
          user,
        };
      })
      .catch((error) => {
        throw new BadRequestException(error.message);
      });
  }
}
