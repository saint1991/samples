import { HttpClient } from '@angular/common/http';
import { Component, inject, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { UserInfo } from '../interfaces/user.interface';

@Component({
  selector: 'app-profile',
  imports: [],
  templateUrl: './profile.html',
  styleUrl: './profile.css'
})
export class Profile implements OnInit {
  protected userId: string | undefined = undefined;
  protected userName: string | undefined = undefined;

  constructor(private readonly route: ActivatedRoute, private readonly client: HttpClient) {}

  ngOnInit(): void {
    const idParam = this.route.snapshot.paramMap.get('id');
    if (idParam) {
      this.userId = idParam;
      this.loadUserInfo(idParam);
    }
  }

  private loadUserInfo(userId: string): void {
    const apiUrl = `http://localhost:4000/user-info?userId=${userId}`;
    const startTime = Date.now();

    console.log(`[Profile] Starting API call to: ${apiUrl}`);

    this.client.get<UserInfo>(apiUrl)
      .subscribe({
        next: (userInfo) => {
          const duration = Date.now() - startTime;
          console.log(`[Profile] API call successful in ${duration}ms. User: ${userInfo.userName}`);
          this.userName = userInfo.userName;
        },
        error: (error) => {
          const duration = Date.now() - startTime;
          console.error(`[Profile] API call failed after ${duration}ms:`, error);
          this.userName = 'Error loading user';
        }
      });
  }
}
