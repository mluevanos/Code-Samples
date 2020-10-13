using System;
using System.Collections.Generic;
using System.Text;

namespace Sabio.Models.Domain
{
    public class Note
    {
        public int Id { get; set; }

        public BaseUserProfile UserInfo { get; set; }

        public string Notes { get; set; }

        public int SeekerId { get; set; }

        public int? TagId { get; set; }

        public DateTime DateCreated { get; set; }

        public int CreatedBy { get; set; }

        
    }
}
