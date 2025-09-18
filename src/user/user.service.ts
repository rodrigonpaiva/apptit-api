import {
  Body,
  HttpException,
  HttpStatus,
  Injectable,
  Post,
} from '@nestjs/common';
import { User } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  findByEmail(tenantId: string, email: string) {
    return this.prisma.user.findFirst({ where: { tenantId, email } });
  }

  updateRefreshHash(userId: string, refreshTokenHash: string | null) {
    return this.prisma.user.update({
      where: { id: userId },
      data: { refreshTokenHash },
    });
  }

  findById(id: string) {
    return this.prisma.user.findUnique({ where: { id } });
  }

  async findAll(): Promise<User[]> {
    const users = await this.prisma.user.findMany();
    return users;
  }

  async findOneById(id: number): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: {
        id: String(id),
      },
      include: {
        tenant: true,
      },
    });
    if (user) {
      return user;
    } else {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }
  }

  @Post()
  createUser(@Body() createUserDto: CreateUserDto) {
    const newUser = {
      name: createUserDto.name,
      email: createUserDto.email,
      password: createUserDto.password,
      role: createUserDto.role,
      avatar: createUserDto.avatar,
      tenantId: createUserDto.tenantId,
    };
    return newUser;
  }
}
