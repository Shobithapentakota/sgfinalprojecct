using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DiscountPortel.Models
{
    public partial class Note
    {
        [Key]
        public int NoteId { get; set; }
        [Column("Note")]
        [StringLength(100)]
        public string Note1 { get; set; }
        public bool? IsActive { get; set; }
    }
}
